import Foundation
import UserNotifications
import UIKit

protocol NotificationManagerProtocol {
	func enableReminderNotifications() async throws -> Void
	func disableReminderNotifications() async throws -> Void
	func reminderNotificationsEnabled() -> Bool
	func enableEventNotifications() async throws -> Void
	func disableEventNotifications() async throws -> Void
	func eventNotificationsEnabled() -> Bool
}

final class NotificationManager: NotificationManagerProtocol {
	@Inject private var api: APIProtocol
	
	let deviceId = UIDevice.current.identifierForVendor?.uuidString
	let reminderNotificationsKey = "ReminderNotificationsEnabled"
	let eventNotificationsKey = "EventNotificationsEnabled"
	
	private func requestPermission() {
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { success, error in
			if let error = error {
				print("failed to get notification permission: \(error)")
				return
			}
		})
	}
	
	func enableReminderNotifications() async throws {
		requestPermission()
		guard let deviceId else {
			throw IdentifierForVendorNotFound()
		}
		do {
			try await api.enableReminderNotifications(deviceId: deviceId)
			UserDefaults.standard.set(true, forKey: reminderNotificationsKey)
		} catch {
			throw APIError.unknown
		}
	}
	
	func disableReminderNotifications() async throws {
		guard let deviceId else {
			throw IdentifierForVendorNotFound()
		}
		do {
			try await api.disableReminderNotifications(deviceId: deviceId)
			UserDefaults.standard.set(false, forKey: reminderNotificationsKey)
		} catch {
			throw APIError.unknown
		}
	}
	
	func reminderNotificationsEnabled() -> Bool {
		return UserDefaults.standard.bool(forKey: reminderNotificationsKey)
	}
	
	func enableEventNotifications() async throws {
		requestPermission()
		guard let deviceId else {
			throw IdentifierForVendorNotFound()
		}
		do {
			try await api.enableEventNotifications(deviceId: deviceId)
			UserDefaults.standard.set(true, forKey: eventNotificationsKey)
		} catch {
			throw APIError.unknown
		}
	}
	
	func disableEventNotifications() async throws {
		guard let deviceId else {
			throw IdentifierForVendorNotFound()
		}
		do {
			try await api.disableEventNotifications(deviceId: deviceId)
			UserDefaults.standard.set(false, forKey: eventNotificationsKey)
		} catch {
			throw APIError.unknown
		}
	}
	
	func eventNotificationsEnabled() -> Bool {
		return UserDefaults.standard.bool(forKey: eventNotificationsKey)
	}
}
