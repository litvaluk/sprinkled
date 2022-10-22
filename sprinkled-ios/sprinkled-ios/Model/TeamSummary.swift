struct TeamSummary: Codable, Identifiable {
	let id: Int
	let name: String
	let places: [TeamSummaryPlace]
}

struct TeamSummaryPlace: Codable, Identifiable, Hashable {
	let id: Int
	let name: String
	let plantEntries: [TeamSummaryPlantEntry]
}

struct TeamSummaryPlantEntry: Codable, Identifiable, Hashable {
	let id: Int
	let name: String
	let headerPictureUrl: String?
}
