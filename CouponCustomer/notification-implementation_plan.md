# OneSignal Push Notification Integration

Integrate OneSignal v5.x (user-centric API) into the Flutter Customer App, replacing the existing stub `NotificationService`. The integration covers user identification post-login, notification deep-link navigation (tap-to-navigate), and tag-based segmentation. **No notification history is stored in the app — notifications are fire-and-forget.**

**OneSignal App ID:** `77ce7f59-2892-4ad8-bd8d-42d74e0d616a`

---

## Implementation Stages

| Stage | Scope | Status |
|---|---|---|
| **Stage 1 — Android** | Phases 1, 2, 3, 5, 7, 8 | ✅ Implement now |
| **Stage 2 — iOS** | Phase 4 (Xcode steps) | 🔜 Deferred — implement later |

---

## User Review Required

> [!IMPORTANT]
> **Firebase (FCM) credentials are required for Android.** OneSignal uses FCM under the hood on Android. You must add the Firebase project's `google-services.json` and configure the FCM Server Key in the OneSignal dashboard → Settings → Platforms → Google Android (FCM). This is a one-time dashboard step, NOT a code change.

> [!NOTE]
> **iOS push (Phase 4) is deferred for later.** When ready, you will need an Apple Developer account with an APNs p8 key or p12 certificate configured in the OneSignal dashboard → Settings → Platforms → Apple iOS. The full Xcode setup is documented in Phase 4 and preserved for future use.

> [!WARNING]
> The existing `NotificationService` stub (`lib/services/notification_service.dart`) returns `'stub-fcm-token'`. This file will be **fully replaced**. It is safe to replace — no other file depends on the returned token value.

> [!NOTE]
> The `AppConfig` class will gain a new `oneSignalAppId` field. The same App ID (`77ce7f59-2892-4ad8-bd8d-42d74e0d616a`) is used across dev and prod — OneSignal uses segments/tags to differentiate environments.

---

## Proposed Changes

---

## 🟢 Stage 1 — Android (Implement Now)

### Phase 1 — Dependency & Config

#### [MODIFY] [pubspec.yaml](file:///e:/CouponApp/CouponCustomer/pubspec.yaml)
Add the following to `dependencies`:
```yaml
onesignal_flutter: ^5.1.2
```

#### [MODIFY] [app_config.dart](file:///e:/CouponApp/CouponCustomer/lib/core/config/app_config.dart)
Add `oneSignalAppId` field. Both `.dev()` and `.prod()` factories will use `77ce7f59-2892-4ad8-bd8d-42d74e0d616a`.

---

### Phase 2 — Core: NotificationService (Full Replacement)

#### [MODIFY] [notification_service.dart](file:///e:/CouponApp/CouponCustomer/lib/services/notification_service.dart)

Replace the stub with a full `NotificationService` backed by OneSignal v5:

| Method | Behaviour |
|---|---|
| `init()` | `OneSignal.initialize(appId)`, set log level, register foreground & click listeners |
| `requestPermission()` | `OneSignal.Notifications.requestPermission(true)` — call after login |
| `identifyUser(userId)` | `OneSignal.login(userId)` — links device to backend user |
| `logout()` | `OneSignal.logout()` — unlinks user on sign-out |
| `setUserTags(Map)` | `OneSignal.User.addTags({...})` — for dashboard segmentation |
| `getOneSignalId()` | Returns `OneSignal.User.pushSubscription.id` |

**Click handler** deep-links via GoRouter based on `additionalData`:
```dart
// Payload schema (backend contract):
// { "type": "COUPON_EXPIRY|REDEMPTION_CONFIRMED|SUBSCRIPTION_REMINDER|GENERAL",
//   "route": "/coupons|/redemption/history|/subscription|/home",
//   "coupon_id": "optional", "seller_id": "optional" }
```

---

### Phase 3 — Android Setup

#### [MODIFY] [AndroidManifest.xml](file:///e:/CouponApp/CouponCustomer/android/app/src/main/AndroidManifest.xml)
Add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```
Add inside `<application>`:
```xml
<meta-data
    android:name="com.onesignal.NotificationOpened.DEFAULT"
    android:value="DISABLE" />
```
*(Disables OneSignal's default open activity — we handle clicks ourselves via click listener)*

#### [NEW] android/app/google-services.json
> [!CAUTION]
> **Manual step.** Download this file from your Firebase console (Project Settings → Your Apps → Android App) and place it at `android/app/google-services.json`. Without this file, Android push notifications will **not work**.

---

---

## 🔜 Stage 2 — iOS (Deferred)

### Phase 4 — iOS Setup (Manual Xcode Steps)

> [!NOTE]
> **Skip this phase for now. Come back here when you are ready to ship on iOS.**
> All steps are documented and preserved in full so nothing needs to be researched again.

**Pre-requisites before starting Phase 4:**
- Mac with Xcode 14+ installed
- Apple Developer account with active membership
- APNs p8 key (from [Apple Developer Portal](https://developer.apple.com/account/resources/authkeys/list)) uploaded to OneSignal Dashboard → Settings → Platforms → Apple iOS

**Steps:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. **Runner target → Signing & Capabilities → + Capability → Push Notifications**
3. **Runner target → Signing & Capabilities → + Capability → Background Modes → ✅ Remote notifications**
4. **Runner target → App Groups → Add** `group.com.couponcode.customer.onesignal`
5. **File → New → Target → Notification Service Extension** → Product Name: `OneSignalNotificationServiceExtension` → click "Don't Activate"
6. **OneSignalNotificationServiceExtension target → Signing & Capabilities → App Groups** → add the exact same group ID from step 4
7. Navigate to the `OneSignalNotificationServiceExtension/` folder and replace `NotificationService.swift` with:
```swift
import UserNotifications
import OneSignalExtension

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            OneSignalExtension.didReceiveNotificationExtensionRequest(
                self.receivedRequest, with: bestAttemptContent,
                withContentHandler: self.contentHandler)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            OneSignalExtension.serviceExtensionTimeWillExpireRequest(
                self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}
```
8. Add to `ios/Podfile` (at the end, outside the main `target` block):
```ruby
target 'OneSignalNotificationServiceExtension' do
  pod 'OneSignalXCFramework', '>= 5.0.0', '< 6.0'
end
```
9. Run:
```bash
cd ios && pod install && cd ..
```
10. In Xcode: Build Phases → drag "Embed Foundation Extensions" **above** "Run Script" if you see a cycle build error.

#### [NEW] [ios/OneSignalNotificationServiceExtension/NotificationService.swift](file:///e:/CouponApp/CouponCustomer/ios/OneSignalNotificationServiceExtension/NotificationService.swift)
File content is the Swift snippet in step 7 above.

**Common iOS Build Errors:**
- `commandPhaseScript exited with non-zero`: Delete `Podfile.lock`, `Pods/`, `.xcworkspace` → re-run `pod install`
- `Cycle Inside`: Drag "Embed Foundation Extensions" above "Run Script" in Build Phases
- `PBXGroup error`: Right-click the NSE folder in Xcode sidebar → "Convert to Group"

---

## 🟢 Stage 1 (continued)

### Phase 5 — User Identification Wiring

#### [MODIFY] [verify_otp_usecase.dart](file:///e:/CouponApp/CouponCustomer/lib/features/auth/domain/usecases/verify_otp_usecase.dart)
After successful OTP verification: call `getIt<NotificationService>().identifyUser(user.id)` and `setUserTags({subscription_status, area, ...})`.

#### [MODIFY] [logout_usecase.dart](file:///e:/CouponApp/CouponCustomer/lib/features/auth/domain/usecases/logout_usecase.dart)
After logout: call `getIt<NotificationService>().logout()`.

#### [MODIFY] [injection.dart](file:///e:/CouponApp/CouponCustomer/lib/core/di/injection.dart)
Update `NotificationService` instantiation to `NotificationService(AppConfig.current.oneSignalAppId)`.

---

### ~~Phase 6 — Notifications Feature~~ (Dropped)

> [!NOTE]
> **Intentionally skipped.** The app will NOT store notification history or show a notifications screen. Notifications are fire-and-forget — OneSignal delivers them to the device OS tray. If the user taps, the click handler deep-links them into the app. No backend API, no database, no UI list required.

---

### Phase 7 — Permission Request UX

#### [MODIFY] Post-OTP auth flow screen
After login success, before navigating to home, show a **custom rationale bottom sheet** ("Allow notifications to get coupon expiry alerts, redemption confirmations, and exclusive offers"). On user acceptance, call `NotificationService.requestPermission()` — which triggers the OS-level permission prompt.

---

### Phase 8 — main.dart Initialization Order

#### [MODIFY] [main.dart](file:///e:/CouponApp/CouponCustomer/lib/main.dart)
Correct initialization sequence (OneSignal must init before `runApp`):
1. `WidgetsFlutterBinding.ensureInitialized()`
2. `AppConfig.setup(AppConfig.dev())`
3. `configureDependencies()`
4. `HiveService.init()`
5. `NotificationService.init()` ← **OneSignal initialized here**
6. `SharedPreferences.getInstance()`
7. `runApp(ProviderScope(...))`

---

## Notification Payload Schema (Backend Contract)

Backend must include `additional_data` when sending notifications via OneSignal API:

```json
{
  "type": "COUPON_EXPIRY | REDEMPTION_CONFIRMED | SUBSCRIPTION_REMINDER | GENERAL",
  "route": "/coupons | /redemption/history | /subscription | /home",
  "coupon_id": "optional-string",
  "seller_id": "optional-string"
}
```

Flutter click handler reads `additionalData['route']` and pushes via `GoRouter`.

---

## OneSignal Segmentation Tags

Set after login via `OneSignal.User.addTags(...)`:

| Tag Key | Example Value | Campaign Use |
|---|---|---|
| `subscription_status` | `active` / `expired` / `none` | Renewal reminders |
| `area` | `Surat` | Local offers |
| `user_id` | `abc123` | Individual targeting |
| `has_redeemed` | `true` / `false` | Re-engagement |
| `env` | `dev` / `prod` | Separate test traffic |


---

## Verification Plan

### Stage 1 Manual Verification (Android)
1. Run on a **physical Android device** (if using emulator: Device Manager → Edit → Cold Boot)
2. Allow notification permission when prompted after OTP login
3. OneSignal Dashboard → Audience → Subscriptions → confirm device appears
4. Add device to **Test Subscriptions**, create a **Test Users** segment
5. Dashboard → Messages → New Push → send to "Test Users"
6. Confirm notification appears in device tray
7. Tap notification → confirm GoRouter navigates to the correct screen (based on `route` in `additional_data`)
8. Log out → confirm OneSignal user is dissociated (device reappears as anonymous in dashboard)

### Stage 2 Manual Verification (iOS — do when Phase 4 is implemented)
1. Run on a **physical iPhone** (simulator does not support push)
2. Use `flutter run --release` or set Xcode scheme to Release
3. Allow notification permission when prompted
4. OneSignal Dashboard → Audience → Subscriptions → confirm iOS device listed
5. Send test push → confirm image attachment and confirmed delivery (requires NSE to work correctly)
