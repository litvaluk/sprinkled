import UIKit
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let pushToken = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
		if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
			@Inject var api: APIProtocol
			Task {
				do {
					try await api.addPushToken(pushToken: pushToken, deviceId: deviceId)
				} catch {
					print(error)
				}
			}
		}
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		@Provider var api = API() as APIProtocol
		@Provider var notificationManager = NotificationManager() as NotificationManagerProtocol
		@Provider var storageManager = StorageManager() as StorageManagerProtocol
		return true
	}
}
