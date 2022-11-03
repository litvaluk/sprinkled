import Foundation

struct Event: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let date: Date
	let userId: Int
	let plantEntryId: Int
	let actionId: Int
	let user: User
	let action: Action
	let completed: Bool
	let reminderId: Int?
}
