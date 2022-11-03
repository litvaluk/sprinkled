import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let pushToken = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
		UserDefaults.standard.set(pushToken, forKey: "pushToken")
	}
}
