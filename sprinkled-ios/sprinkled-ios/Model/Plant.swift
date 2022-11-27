import Foundation

struct Plant: Codable, Identifiable, Hashable {
	let id: Int
	let latinName: String
	let commonName: String
	let description: String
	let pictureUrl: String
	let difficulty: String
	let water: String
	let minHeight: Double
	let maxHeight: Double
	let minSpread: Double
	let maxSpread: Double
	let minTemp: Int
	let maxTemp: Int
	let light: String
	let plans: [Plan]
}

struct Plan: Codable, Identifiable, Hashable {
	let id: Int
	let name: String
	let plantId: Int
	let reminderBlueprints: [ReminderBlueprint]
}

struct ReminderBlueprint: Codable, Identifiable, Hashable {
	let id: Int
	let period: Int
	let actionId: Int
	let planId: Int
	let action: Action
}
