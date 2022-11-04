import Foundation
import SwiftUI
import JWTDecode

final class ProfileViewModel: ObservableObject {
	private var notificationManager: NotificationManagerProtocol
	private var api: APIProtocol
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
	@Published var unitSystemSelection = "Metric"
	@Published var reminderNotificationsEnabled: Bool
	@Published var eventNotificationsEnabled: Bool
	
	init() {
		@Inject var notificationManager: NotificationManagerProtocol
		@Inject var api: APIProtocol
		self.notificationManager = notificationManager
		self.api = api
		reminderNotificationsEnabled = notificationManager.reminderNotificationsEnabled()
		eventNotificationsEnabled = notificationManager.eventNotificationsEnabled()
	}
	
	func logout() {
		accessToken = ""
		refreshToken = ""
	}
	
	func getAuthenticatedUser() -> String? {
		return try? decode(jwt: accessToken).username
	}
	
	@MainActor
	func onReminderNotificationsToggleChange() async {
		do {
			if (reminderNotificationsEnabled) {
				try await notificationManager.enableReminderNotifications()
			} else {
				try await notificationManager.disableReminderNotifications()
			}
		} catch {
			print("❌ Error while toggling reminder notifications.")
		}
	}
	
	@MainActor
	func onEventNotificationsToggleChange() async {
		do {
			if (eventNotificationsEnabled) {
				try await notificationManager.enableEventNotifications()
			} else {
				try await notificationManager.disableEventNotifications()
			}
		} catch {
			print("❌ Error while toggling event notifications.")
		}
	}
}
