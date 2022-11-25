import Foundation

struct Event: Codable, Identifiable, Comparable, Hashable, Equatable {
	let id: Int
	let date: Date
	let userId: Int?
	let plantEntryId: Int
	let actionId: Int
	let user: User?
	let action: Action
	let completed: Bool
	let reminded: Bool?
	let reminderId: Int?
	let plantEntry: PlantEntryIdAndName
	
	struct PlantEntryIdAndName: Codable, Identifiable, Hashable, Equatable {
		let id: Int
		let name: String
	}
	
	static func < (lhs: Event, rhs: Event) -> Bool {
		return lhs.date < rhs.date
	}
}
