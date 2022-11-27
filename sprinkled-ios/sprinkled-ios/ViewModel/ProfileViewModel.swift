import Foundation
import SwiftUI
import JWTDecode

final class ProfileViewModel: ObservableObject {
	private var notificationManager: NotificationManagerProtocol
	private var api: APIProtocol
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	@AppStorage("unitSystem") var unitSystem = "Metric"
	
	@Published var reminderNotificationsEnabled: Bool
	@Published var eventNotificationsEnabled: Bool
	
	private let errorPopupsState: ErrorPopupsState
	private let tabBarState: TabBarState
	
	init(errorPopupsState: ErrorPopupsState, tabBarState: TabBarState) {
		@Inject var notificationManager: NotificationManagerProtocol
		@Inject var api: APIProtocol
		self.notificationManager = notificationManager
		self.api = api
		reminderNotificationsEnabled = notificationManager.reminderNotificationsEnabled()
		eventNotificationsEnabled = notificationManager.eventNotificationsEnabled()
		self.errorPopupsState = errorPopupsState
		self.tabBarState = tabBarState
	}
	
	func logout() {
		if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
			Task {
				do {
					try await api.logout(deviceId: deviceId)
				} catch {
					// nothing
				}
				accessToken = ""
				refreshToken = ""
				tabBarState.selection = 0
			}
		}
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
			errorPopupsState.showGenericError = true
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
			errorPopupsState.showGenericError = true
		}
	}
}
