import Foundation

struct Reminder: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let date: Date
	let period: Int
	let actionId: Int
	let plantEntryId: Int
	let creatorId: Int
	let action: Action
}

struct ReminderForTaskView: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let date: Date
	let period: Int
	let action: Action
	let plantEntry: PlantEntryIdAndName
	
	struct PlantEntryIdAndName: Codable, Identifiable, Hashable, Equatable {
		let id: Int
		let name: String
	}
}
