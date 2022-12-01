import Foundation
import SwiftUI
import JWTDecode

final class ProfileViewModel: ObservableObject {
	private var notificationManager: NotificationManagerProtocol
	private var api: APIProtocol
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	@AppStorage("unitSystem") var unitSystem = "Metric"
	@AppStorage("ReminderNotificationsEnabled") var reminderNotificationsEnabled = false
	@AppStorage("EventNotificationsEnabled") var eventNotificationsEnabled = false
	
	@Published var showDeleteAccountModal = false
	
	private let errorPopupsState: ErrorPopupsState
	private let tabBarState: TabBarState
	
	init(errorPopupsState: ErrorPopupsState, tabBarState: TabBarState) {
		@Inject var notificationManager: NotificationManagerProtocol
		@Inject var api: APIProtocol
		self.notificationManager = notificationManager
		self.api = api
		self.errorPopupsState = errorPopupsState
		self.tabBarState = tabBarState
	}
	
	@MainActor
	func logout() {
		guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
			errorPopupsState.showGenericError = true
			return
		}
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
	
	@MainActor
	func deleteAccount() async -> Bool {
		guard let userId = getAuthenticatedUserId() else {
			errorPopupsState.showGenericError = true
			return false
		}
		do {
			try await api.deleteAccount(userId: userId)
		} catch {
			errorPopupsState.showGenericError = true
			return false
		}
		accessToken = ""
		refreshToken = ""
		tabBarState.selection = 0
		return true
	}
	
	func getAuthenticatedUser() -> String? {
		return try? decode(jwt: accessToken).username
	}
	
	func getAuthenticatedUserId() -> Int? {
		return try? decode(jwt: self.accessToken).userId
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
