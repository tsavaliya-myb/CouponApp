Phase 1 — Blockers (must ship together)
These three are coupled: they all touch the SI hash flow. Without all three, payments will keep failing.

1.1 Fix webhook reverse-hash to include si_details — payuHash.ts:112-127
Replace verifyPayUWebhookHash with the SI-aware version (doc §4.1). Try both withSi and core candidates; also handle additionalCharges prefix.

1.2 Drop pre-computed payment hash and stop sending hashes via additionalParam — payments.service.ts:48-88

Remove generateSIPayUHash(...) call
Remove generateMobileSDKStaticHashes(...) and the additionalParam block
Remove userCredential (set to '' in response)
Strip +91 from phone
Response shape becomes: { key, txnid, amount, productinfo, firstname, email, phone, userCredential: '', env, si_details }
Delete generateSIPayUHash and generateMobileSDKStaticHashes exports from payuHash.ts (dead code after this)
1.3 Mobile: stop forwarding additionalParam, add isPreAuthTxn — payu_service.dart:39-71

Delete the additionalParam block (lines 39-41, 57-58)
Add PayUSIParamsKeys.isPreAuthTxn: true inside payUSIParams
Optionally point android_surl/furl at a real api.couponapp.in path
Phase 2 — Mandate longevity & durability
2.1 30-year mandate — payments.service.ts:33-46
Change end.setFullYear(end.getFullYear() + 1) → + 30. Add remarks: 'CouponApp Annual Subscription' into siParams itself (dedupes the duplicate block at lines 78-87).

2.2 Bump txnid Redis TTL to 48 h — payments.service.ts:61
One-line: 'EX', 48 * 3600.

2.3 New PaymentAttempt Prisma model — schema.prisma
Add the model + PaymentAttemptStatus enum from doc §10. Wire into Subscription (attempts PaymentAttempt[]) and User. Run prisma migrate dev --name payu_payment_attempts.

2.4 Persist attempts in initiatePayment + handleWebhook — payments.service.ts

On initiate: create PaymentAttempt row with status=PENDING, kind='MANDATE'
On webhook: update to SUCCESS or FAILED with payuPaymentId, authPayUID, errorMessage, rawWebhook
Resolve userId from Redis OR from PaymentAttempt table as a fallback
Phase 3 — Cleanup
3.1 Rewrite Swagger doc — payments.swagger.ts — currently still says Razorpay / x-razorpay-signature / /create-order. Replace with /initiate, /generate-hash, /webhook (PayU form-urlencoded).

3.2 Rewrite validator — payments.validator.ts — createOrderResponseSchema → initiatePaymentResponseSchema matching the new response shape.

3.3 Profile-polling on success — payment_controller.dart:60-66 — replace fixed 3 s delay with the up-to-5-attempts loop from doc §5.6.

Phase 4 — Recurring debits + RBI compliance (separate decision)
This is roughly a week of work and is not required for the first sale to succeed. Phases 1-3 unblock the immediate ₹999 charge; Phase 4 is what makes auto-renewal actually fire next year.

Extend Subscription with mandateStartDate, mandateEndDate, preDebitNotifiedAt, lastRenewalAt, renewalFailureCount (doc §10)
New src/jobs/preDebitNotification.ts — daily 09:00 IST BullMQ job, push + MSG91 SMS ≥24h before debit
New src/jobs/recurringDebits.ts — daily BullMQ job calling PayU's si_transaction endpoint with SHA512(key|si_transaction|var1|SALT) hash
Failure handling per doc §8 table (E000 retry, E001 expire-and-notify)
Question for you: do you want me to scope Phase 4 in this plan, or treat it as a separate workstream after Phase 1-3 ships? The first annual auto-debit isn't due for 365 days, so there's no rush.

Suggested execution order
Phase 1 in one PR (blockers — atomic; can't ship in pieces)
Phase 2 in a second PR (schema migration + durability)
Phase 3 as cleanup, can piggyback on either PR
Phase 4 as its own milestone after we confirm Phase 1 works end-to-end with sandbox credentials (gtKFFx / eCwWELxi, VPA success@payu)
