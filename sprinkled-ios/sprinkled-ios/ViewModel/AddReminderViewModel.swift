import SwiftUI

final class AddReminderViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var actionSelection = "water"
	@Published var date = Date().zeroSeconds()
	@Published var repeating = false
	@Published var period = 1
	@Published var periodPickerOpen = false
	
	@Published var isProcessing = false
	
	let plantEntryId: Int
	let plantEntryName: String
	let actions = TestData.actions
	
	private let errorPopupsState: ErrorPopupsState
	
	init(plantEntryId: Int, plantEntryName: String, errorPopupsState: ErrorPopupsState) {
		self.plantEntryId = plantEntryId
		self.plantEntryName = plantEntryName
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func addNewReminder() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		do {
			_ = try await api.addReminder(plantEntryId: plantEntryId, actionId: actions.first(where: {$0.type == actionSelection})!.id, date: date, period: repeating ? period : 0)
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
