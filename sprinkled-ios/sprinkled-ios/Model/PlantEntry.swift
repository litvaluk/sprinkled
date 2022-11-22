import Foundation

struct PlantEntry: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let name: String
	let createdAt: Date
	let creatorId: Int
	let placeId: Int
	let plantId: Int
	let plant: PlantForPlantEntry
	let headerPictureUrl: String?
	let events: [Event]
	let reminders: [Reminder]
	let pictures: [Picture]
	
	struct PlantForPlantEntry: Codable, Hashable, Equatable {
		let commonName: String
	}
}
