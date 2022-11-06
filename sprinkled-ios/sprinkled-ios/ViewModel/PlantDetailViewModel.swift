import Foundation
import SwiftUI

final class PlantDetailViewModel: ObservableObject {
	@AppStorage("unitSystem") var unitSystem = "Metric"
	
	let plant: Plant
	
	init(plant: Plant) {
		self.plant = plant
	}
}

