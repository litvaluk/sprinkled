import SwiftUI

final class EditReminderViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var actionSelection: String
	@Published var date: Date
	@Published var repeating: Bool
	@Published var period: Int
	@Published var periodPickerOpen = false
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	let plantEntryId: Int
	let plantEntryName: String
	let reminderId: Int
	let actions = TestData.actions
	
	private let errorPopupsState: ErrorPopupsState
	
	init(plantEntryId: Int, plantEntryName: String, reminder: Reminder, errorPopupsState: ErrorPopupsState) {
		self.plantEntryId = plantEntryId
		self.plantEntryName = plantEntryName
		self.actionSelection = reminder.action.type
		self.date = reminder.date
		self.period = reminder.period
		self.repeating = reminder.period > 0
		self.reminderId = reminder.id
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func editReminder() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		if (date <= Date()) {
			errorMessage = "Unable to add reminder with a past date."
			return false
		}
		
		do {
			_ = try await api.editReminder(reminderId: reminderId, actionId: actions.first(where: {$0.type == actionSelection})!.id, date: date, period: period)
			return true
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
		return false
	}
}
