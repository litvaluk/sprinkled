import SwiftUI

final class PlantEntryViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var plantEntry: PlantEntry?
	@Published var selectedSection: PlantEntrySection = .history
	
	
	
	let plantEntryId: Int
	
	
	init(plantEntryId: Int) {
		self.plantEntryId = plantEntryId
		self.plantEntry = nil
	}
	
	
}

enum PlantEntrySection : String, CaseIterable {
	case history = "History"
	case reminders = "Reminders"
	case gallery = "Gallery"
}
