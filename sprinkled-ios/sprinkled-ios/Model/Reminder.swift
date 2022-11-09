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
