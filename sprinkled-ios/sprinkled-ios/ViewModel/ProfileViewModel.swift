import Foundation
import SwiftUI
import JWTDecode

final class ProfileViewModel: ObservableObject {
	private var notificationManager: NotificationManagerProtocol
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
	@Published var unitSystemSelection = 0
	@Published var reminderNotificationsEnabled: Bool
	@Published var eventNotificationsEnabled: Bool
	
	init() {
		@Inject var notificationManager: NotificationManagerProtocol
		self.notificationManager = notificationManager
		reminderNotificationsEnabled = notificationManager.reminderNotificationsEnabled()
		eventNotificationsEnabled = notificationManager.eventNotificationsEnabled()
	}
	
	func logout() {
		accessToken = ""
		refreshToken = ""
	}
	
	func getAuthenticatedUser() -> String? {
		return try? decode(jwt: accessToken).claim(name: "username").string
	}
	
	func onReminderNotificationsToggleChange() {
		if (reminderNotificationsEnabled) {
			notificationManager.enableReminderNotifications()
		} else {
			notificationManager.disableReminderNotifications()
		}
	}
	
	func onEventNotificationsToggleChange() {
		if (eventNotificationsEnabled) {
			notificationManager.enableEventNotifications()
		} else {
			notificationManager.disableEventNotifications()
		}
	}
}
