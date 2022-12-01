import Foundation

struct Reminder: Codable, Identifiable, Hashable, Equatable, Comparable {
	let id: Int
	let date: Date
	let period: Int
	let actionId: Int
	let plantEntryId: Int
	let creatorId: Int?
	let action: Action
	
	static func < (lhs: Reminder, rhs: Reminder) -> Bool {
		return lhs.date < rhs.date
	}
}
