import Foundation
import SwiftUI
import JWTDecode

final class ProfileViewModel: ObservableObject {
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
	@Published var unitSystemSelection = 0
	@Published var reminderNotificationsEnabled: Bool
	@Published var eventNotificationsEnabled: Bool
	
	typealias Dependencies = HasAPI & HasNotificationManager
	private let dependencies: Dependencies
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		reminderNotificationsEnabled = dependencies.notificationManager.reminderNotificationsEnabled()
		eventNotificationsEnabled = dependencies.notificationManager.eventNotificationsEnabled()
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
			dependencies.notificationManager.enableReminderNotifications()
		} else {
			dependencies.notificationManager.disableReminderNotifications()
		}
	}
	
	func onEventNotificationsToggleChange() {
		if (eventNotificationsEnabled) {
			dependencies.notificationManager.enableEventNotifications()
		} else {
			dependencies.notificationManager.disableEventNotifications()
		}
	}
}
