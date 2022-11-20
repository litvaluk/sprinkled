import Foundation
import SwiftUI

final class PlantDetailViewModel: ObservableObject {
	@AppStorage("unitSystem") var unitSystem = "Metric"
	
	@Published var addPlantEntryPresented = false
	@Published var setupPlanPresented = false
	@Published var lastCreatedPlantEntryId: Int? = nil
	
	let plant: Plant
	
	init(plant: Plant) {
		self.plant = plant
	}
}

