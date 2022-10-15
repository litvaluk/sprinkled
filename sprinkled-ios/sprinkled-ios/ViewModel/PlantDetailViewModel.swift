import Foundation
import SwiftUI

final class PlantDetailViewModel: ObservableObject {
	let plant: Plant
	
	init(plant: Plant) {
		self.plant = plant
	}
}

