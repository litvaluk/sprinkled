import Foundation

struct Reminder: Codable {
	let id: Int
	let date: Date
	let period: Int
	let actionId: Int
	let plantEntryId: Int
	let creatorId: Int
}
