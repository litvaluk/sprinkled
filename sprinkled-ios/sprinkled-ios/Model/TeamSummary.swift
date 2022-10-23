struct TeamSummary: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let name: String
	let places: [TeamSummaryPlace]
}

struct TeamSummaryPlace: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let name: String
	let plantEntries: [TeamSummaryPlantEntry]
}

struct TeamSummaryPlantEntry: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let name: String
	let headerPictureUrl: String?
}
