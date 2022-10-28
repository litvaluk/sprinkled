import Foundation

struct Picture: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let url: String
	let createdAt: Date
	let userId: Int
	let plantEntryId: Int
	let user: User
}
