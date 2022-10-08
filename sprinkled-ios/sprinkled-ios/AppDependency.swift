final class AppDependency {
	fileprivate init() {}
	
	lazy var api: APIType = API()
	lazy var notificationManager: NotificationManagerType = NotificationManager()
}

extension AppDependency: HasAPI {}
extension AppDependency: HasNotificationManager {}

let dependencies = AppDependency()

