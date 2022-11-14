struct ErrorResponse: Codable {
	var statusCode: Int
	var descriptions: [String]
	var error: String

	private enum CodingKeys: String, CodingKey {
		case statusCode
		case descriptions = "message"
		case error
	}
}
