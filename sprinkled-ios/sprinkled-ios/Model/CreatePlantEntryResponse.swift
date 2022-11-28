import Foundation

struct CreatePlantEntryResponse: Codable, Identifiable {
	let id: Int
	let name: String
	let createdAt: Date
	let creatorId: Int
	let placeId: Int
	let plantId: Int
	let headerPictureUrl: String?
}
