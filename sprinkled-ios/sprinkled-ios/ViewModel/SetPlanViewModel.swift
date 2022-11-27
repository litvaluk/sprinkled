import SwiftUI

final class SetPlanViewModel: ObservableObject {
	@Published var planSelection: Int
	@Published var reminderTime: Date = Date()
	
	let plantEntry: PlantEntry
	let plans: [Plan]
	
	init(plantEntry: PlantEntry, plans: [Plan]) {
		self.plantEntry = plantEntry
		self.plans = plans
		self.planSelection = plans.first!.id
	}
	
	func setPlan() async -> Bool {
		// MARK: TODO
		true
	}
}
