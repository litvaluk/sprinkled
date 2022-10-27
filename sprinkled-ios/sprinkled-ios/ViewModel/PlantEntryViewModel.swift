import SwiftUI

final class PlantEntryViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var plantEntry: PlantEntry?
	@Published var selectedSection: PlantEntrySection = .history
	@Published var loading = false
	let plantEntryId: Int

	init(plantEntryId: Int) {
		self.plantEntryId = plantEntryId
	}
	
	@MainActor
	func fetchPlantEntry() async {
		loading = true
		defer { loading = false }
		do {
			plantEntry = try await api.fetchPlantEntry(plantEntryId: plantEntryId)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
		}
	}
}

enum PlantEntrySection : String, CaseIterable {
	case history = "History"
	case reminders = "Reminders"
	case gallery = "Gallery"
}
