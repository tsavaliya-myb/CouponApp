# Line of Business (LoB) & Payment Flow Document

**Platform Name:** CouponCode
**Entity Name:** Triedge Wellness co 
**Date:** 14/04/2026

---

## 1. Business Overview
**CouponCode** is a localized, subscription-based digital coupon platform. We partner with local businesses (merchants) such as restaurants, salons, cafes, and theatres to offer exclusive discounts to our paid subscribers. 

Our application bridges the gap between local businesses looking to acquire new customers and consumers looking for cost-saving opportunities in their city.

## 2. Goods and Services Provided
- **Nature of Business:** SaaS / Digital Subscription Services.
- **Product Sold via Payment Gateway:** A time-bound digital subscription (Digital Coupon Book).
- **Service Delivery:** Immediate & Digital. Upon successful transaction, the user's account is instantly credited with the active subscription, unlocking digital coupons within the mobile application. No physical goods are shipped.

## 3. Revenue & Payment Model
Our business generates revenue through two distinct channels. **Only the Consumer Subscription fee is processed through the Payment Gateway.**

### A. Consumer Subscription Fee (Processed via Payment Gateway)
- **What it is:** Consumers pay a flat subscription fee (e.g., ₹1000) to access the digital coupon book.
- **Validity:** The subscription is valid for a fixed period (e.g., 45-50 days).
- **Payment Method:** Processed 100% online through our integrated payment gateway via UPI, Credit/Debit Cards, or NetBanking. 

### B. Merchant Commission (Processed Offline / B2B)
- **What it is:** When a consumer redeems a coupon at a partner merchant, the consumer pays the final discounted bill *directly* to the merchant at their physical outlet (via cash or the merchant's own UPI/POS). 
- **Commission:** Our platform applies a flat/percentage-based marketing commission on these redemptions.
- **Payment Method:** This commission is settled directly between our company and the merchant on a weekly basis via standard B2B bank transfers. **The Payment Gateway is NOT used for this leg of the transaction.**

---

## 4. Payment Flow & Customer Journey (Step-by-Step)

To clarify the exact touchpoints where PayU services are utilized, please refer to the following workflow:

1. **User Registration:** The customer downloads the app and registers using their mobile number (OTP verified).
2. **Subscription Prompt:** The customer browses locked offers and selects the "Buy Subscription" option.
3. **Checkout / Gateway Initiation:** The app calls the PayU Payment Gateway checkout page for the fixed subscription amount (e.g., ₹1000).
4. **Transaction Processing:** The customer securely completes the payment via PayU.
5. **Service Delivery:** Upon receiving a successful payment webhook/callback from PayU, the app instantly un-blurs the coupons and changes the customer's status to "Active Subscriber". An invoice is generated and provided to the customer.
6. **Coupon Redemption (Off-Gateway):** The active user visits a partner merchant, shows their App QR code, and redeems a discount. The customer pays the merchant directly for the availed services/food. Our platform does not act as an escrow or payment intermediary for the merchant's goods.

## 5. Legality & Compliance Assurances
To satisfy banking and payment gateway compliance requirements, we confirm the following:
- **No Escrow / Nodal Requirement:** We do not collect money on behalf of merchants to settle it later. Customers pay merchants directly for their goods/services. The payment processed via PayU is purely for our own digital software service.
- **No Physical Delivery Risk:** Since the product is a digital activation, there are no physical fulfillment delays, shipping/tracking risks, or inventory issues, resulting in negligible chargeback risks related to non-delivery.
- **Clear Value Proposition:** The user is explicitly shown the validity, terms of use, and benefits of the subscription prior to making the payment.
- **Legal Entity:** We onboard merchants through verified offline agreements outlining our marketing and commission terms. 

***

*This document serves as an accurate representation of the business logic and money flow of the CouponCode platform. Please let us know if additional KYC, Terms of Service, or documentation are required to finalize the payment gateway approval process.*
