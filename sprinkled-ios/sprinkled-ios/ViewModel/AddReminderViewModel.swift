import SwiftUI

final class AddReminderViewModel: ObservableObject {
	@Inject private var api: APIProtocol

	@Published var actionSelection = 1
	@Published var date = Date()
	@Published var repeating = false
	@Published var period = 1
	@Published var periodPickerOpen = false
	
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
	func addNewReminder() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		do {
			_ = try await api.addReminder(plantEntryId: plantEntryId, actionId: actionSelection, date: date, period: repeating ? period : 0)
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
