import SwiftUI

final class EditEventViewModel: ObservableObject {
	@Inject private var api: APIProtocol

	@Published var actionSelection: String
	@Published var date: Date
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	let plantEntryId: Int
	let plantEntryName: String
	let eventId: Int
	let actions = TestData.actions
	
	private let errorPopupsState: ErrorPopupsState
	
	init(plantEntryId: Int, plantEntryName: String, event: Event, errorPopupsState: ErrorPopupsState) {
		self.plantEntryId = plantEntryId
		self.plantEntryName = plantEntryName
		self.actionSelection = event.action.type
		self.date = event.date
		self.eventId = event.id
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func editEvent() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		if (date > Date()) {
			errorMessage = "Unable to add event with a future date."
			return false
		}
		
		do {
			_ = try await api.editEvent(eventId: eventId, actionId: actions.first(where: {$0.type == actionSelection})!.id, date: date)
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
