import Foundation
import SwiftUI

final class PlantDetailViewModel: ObservableObject {
	let plant: Plant
	
	typealias Dependencies = HasAPI & HasNotificationManager
	private let dependencies: Dependencies
	
	init(plant: Plant, dependencies: Dependencies) {
		self.plant = plant
		self.dependencies = dependencies
	}
}

