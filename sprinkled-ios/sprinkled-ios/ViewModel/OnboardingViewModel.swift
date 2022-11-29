import SwiftUI

final class OnboardingViewModel: ObservableObject {
	@Inject var notificationManager: NotificationManagerProtocol
	@Published var currentStep = 0
	@AppStorage("showOnboarding") var showOnboarding: Bool = false
	
	private let errorPopupsState: ErrorPopupsState
	let stepCount = 6
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func enableNotifications() {
		Task {
			do {
				try await notificationManager.enableReminderNotifications()
				try await notificationManager.enableEventNotifications()
			} catch {
				print("❌ Error while toggling reminder notifications.")
				errorPopupsState.showGenericError = true
			}
		}
	}
}
