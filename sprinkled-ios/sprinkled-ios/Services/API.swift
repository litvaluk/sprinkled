import Foundation
import JWTDecode

protocol APIProtocol {
	func signIn(_ username: String, _ password: String) async throws -> Void
	func signUp(_ username: String, _ email: String, _ password: String) async throws -> Void
	func fetchPlants() async throws -> [Plant]
	func fetchTeamSummaries() async throws -> [TeamSummary]
	func refreshToken() async -> Void
}

final class API : APIProtocol {
	let baseUrl = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://sprinkled-app.herokuapp.com"
	
	func signIn(_ username: String, _ password: String) async throws {
		let body = [
			"username": username,
			"password": password
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		let response: AuthResponse = try await makeRequest(path: "auth/login", method: "POST", body: bodyData)
		UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
		UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
	}
	
	func signUp(_ username: String, _ email: String, _ password: String) async throws {
		let body = [
			"username": username,
			"email": email,
			"password": password
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		let response: AuthResponse = try await makeRequest(path: "auth/register", method: "POST", body: bodyData)
		UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
		UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
	}
	
	func fetchPlants() async throws -> [Plant] {
		return try await makeAuthenticatedRequest(path: "plants")
	}
	
	func fetchTeamSummaries() async throws -> [TeamSummary] {
		return try await makeAuthenticatedRequest(path: "teams/summary")
	}
	
	func refreshToken() async {
		print("🔑", "Refreshing access token")
		let url = URL(string: "\(baseUrl)/auth/refresh")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let headers = request.allHTTPHeaderFields ?? [:]
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		request.allHTTPHeaderFields = headers.merging(["Authorization": "Bearer \(refreshToken)"], uniquingKeysWith: { $1 })

		let (data, response) = try! await performDataRequest(for: request)
		
		if ((response as? HTTPURLResponse)?.statusCode == 401) {
			UserDefaults.standard.set("", forKey: "accessToken")
			UserDefaults.standard.set("", forKey: "refreshToken")
			return
		}
		
		let authResponse = try! JSONDecoder.app.decode(AuthResponse.self, from: data)
		UserDefaults.standard.set(authResponse.accessToken, forKey: "accessToken")
		UserDefaults.standard.set(authResponse.refreshToken, forKey: "refreshToken")
	}
	
	private func makeRequest<Response: Decodable>(
		path: String,
		query: [URLQueryItem] = [],
		method: String? = nil,
		body: Data? = nil
	) async throws -> Response {
		let request = try prepareRequest(path: path, query: query, method: method, body: body)
		let (data, _) = try await performDataRequest(for: request)
		return try JSONDecoder.app.decode(Response.self, from: data)
	}
	
	private func makeAuthenticatedRequest<Response: Decodable>(
		path: String,
		query: [URLQueryItem] = [],
		method: String? = nil,
		body: Data? = nil
	) async throws -> Response {
		if (!isTokenValid(UserDefaults.standard.string(forKey: "accessToken"))) {
			await refreshToken()
		}
		
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		if (refreshToken.isEmpty) {
			throw ExpiredRefreshToken()
		}

		var request = try prepareAuthenticatedRequest(path: path, query: query, method: method, body: body)
		let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
		let headers = request.allHTTPHeaderFields ?? [:]
		request.allHTTPHeaderFields = headers.merging(["Authorization": "Bearer \(accessToken)"], uniquingKeysWith: { $1 })
		let (data, _) = try! await performDataRequest(for: request)
		
		return try JSONDecoder.app.decode(Response.self, from: data)
	}

	private func prepareRequest(
		path: String,
		query: [URLQueryItem] = [],
		method: String? = nil,
		body: Data? = nil
	) throws -> URLRequest {
		var components = URLComponents(
			url: URL(string: "\(baseUrl)/\(path)")!,
			resolvingAgainstBaseURL: false
		)
		if !query.isEmpty {
			components?.queryItems = query
		}
		
		guard let url = components?.url else { throw InvalidURL() }
		
		var request = URLRequest(url: url)
		request.httpBody = body
		request.httpMethod = method
		let headers = request.allHTTPHeaderFields ?? [:]
		request.allHTTPHeaderFields = headers.merging([
			"Content-Type": "application/json",
		], uniquingKeysWith: { $1 })
		
		return request
	}

	private func prepareAuthenticatedRequest(
		path: String,
		query: [URLQueryItem] = [],
		method: String? = nil,
		body: Data? = nil
	) throws -> URLRequest {
		var request = try prepareRequest(path: path, query: query, method: method, body: body)
		let headers = request.allHTTPHeaderFields ?? [:]
		let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
		request.allHTTPHeaderFields = headers.merging(["Authorization": "Bearer \(accessToken)"], uniquingKeysWith: { $1 })
		return request
	}
	
	private func performDataRequest(for request: URLRequest) async throws -> (Data, URLResponse) {
		print("⬆️", request.url!.absoluteString)
//		if let body = request.httpBody {
//			print("BODY:", String(data: body, encoding: .utf8)!)
//		}
		let (data, response) = try await URLSession.shared.data(for: request)
		print("⬇️", request.url!.absoluteString, "[", (response as? HTTPURLResponse)?.statusCode ?? 0, "]")
//		print(String(data: data, encoding: .utf8)!)
		return (data, response)
	}

	private func isTokenValid(_ token: String?) -> Bool {
		guard let token else {
			return false
		}
		do {
			let decoded = try decode(jwt: token)
			return !decoded.expired
		} catch {
			return false
		}
	}
}

final class TestAPI : APIProtocol {
	func signIn(_ username: String, _ password: String) async throws {
		return
	}
	
	func signUp(_ username: String, _ email: String, _ password: String) async throws {
		return
	}
	
	func fetchPlants() async throws -> [Plant] {
		return TestData.plants
	}
	
	func refreshToken() async {
		return
	}
	
	func fetchTeamSummaries() async throws -> [TeamSummary] {
		return TestData.teamSummaries
	}
}
