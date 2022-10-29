import SwiftUI

final class AddEventViewModel: ObservableObject {
	@Inject private var api: APIProtocol

	@Published var actionSelection = 1
	@Published var date = Date()
	
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	let plantEntryId: Int
	let plantEntryName: String
	let actions = TestData.actions
	
	init(plantEntryId: Int, plantEntryName: String) {
		self.plantEntryId = plantEntryId
		self.plantEntryName = plantEntryName
	}
	
	@MainActor
	func addNewEvent() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		do {
			_ = try await api.addEvent(plantEntryId: plantEntryId, actionId: actionSelection, date: date)
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
