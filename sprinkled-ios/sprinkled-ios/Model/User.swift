struct User: Codable, Identifiable, Hashable, Equatable {
	let id: Int
	let username: String
	let email: String
}
