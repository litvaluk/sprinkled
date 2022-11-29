import Foundation

struct Picture: Codable, Identifiable, Hashable, Equatable, Comparable {
	let id: Int
	let url: String
	let createdAt: Date
	let userId: Int
	let plantEntryId: Int
	let user: User
	
	static func < (lhs: Picture, rhs: Picture) -> Bool {
		return lhs.createdAt < rhs.createdAt
	}
}
