import Foundation
import UserNotifications
import UIKit

protocol HasNotificationManager {
	var notificationManager: NotificationManagerType { get }
}

protocol NotificationManagerType {
	func enableReminderNotifications() -> Void
	func disableReminderNotifications() -> Void
	func reminderNotificationsEnabled() -> Bool
	func enableEventNotifications() -> Void
	func disableEventNotifications() -> Void
	func eventNotificationsEnabled() -> Bool
}

final class NotificationManager: NotificationManagerType {
	let reminderNotificationsKey = "ReminderNotificationsEnabled"
	let eventNotificationsKey = "EventNotificationsEnabled"
	
	private func requestPermission() {
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { success, error in
			if let error = error {
				print("failed to get notification permission: \(error)")
				return
			}
			DispatchQueue.main.async {
			  UIApplication.shared.registerForRemoteNotifications()
			}
		})
	}
	
	func enableReminderNotifications() -> Void {
		requestPermission()
		UserDefaults.standard.set(true, forKey: reminderNotificationsKey)
	}
	
	func disableReminderNotifications() -> Void {
		UserDefaults.standard.set(false, forKey: reminderNotificationsKey)
	}
	
	func reminderNotificationsEnabled() -> Bool {
		return UserDefaults.standard.bool(forKey: reminderNotificationsKey)
	}
	
	func enableEventNotifications() -> Void {
		requestPermission()
		UserDefaults.standard.set(true, forKey: eventNotificationsKey)
	}
	
	func disableEventNotifications() -> Void {
		UserDefaults.standard.set(false, forKey: eventNotificationsKey)
	}
	
	func eventNotificationsEnabled() -> Bool {
		return UserDefaults.standard.bool(forKey: eventNotificationsKey)
	}
}
