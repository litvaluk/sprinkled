struct IdentifierForVendorNotFound: Error {}
struct InvalidPushToken: Error {}

enum APIError: Error {
	case connectionFailed
	case cancelled
	case invalidURL
	case expiredRefreshToken
	case unknown
}

enum StorageManagerError: Error {
	case conversionError
}
