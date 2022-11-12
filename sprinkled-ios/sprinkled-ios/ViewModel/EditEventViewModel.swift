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
	
	init(plantEntryId: Int, plantEntryName: String, event: Event) {
		self.plantEntryId = plantEntryId
		self.plantEntryName = plantEntryName
		self.actionSelection = event.action.type
		self.date = event.date
		self.eventId = event.id
	}
	
	@MainActor
	func editEvent() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		do {
			_ = try await api.editEvent(eventId: eventId, actionId: actions.first(where: {$0.type == actionSelection})!.id, date: date)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
			return false
		} catch {
			errorMessage = "Something went wrong."
			return false
		}
		
		return true
	}
}
