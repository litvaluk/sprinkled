import Foundation
import JWTDecode

protocol APIProtocol {
	func signIn(_ username: String, _ password: String, _ deviceId: String) async throws -> Void
	func signUp(_ username: String, _ email: String, _ password: String, _ deviceId: String) async throws -> Void
	func logout(deviceId: String) async throws -> Void
	func fetchPlants() async throws -> [Plant]
	func fetchTeamSummaries() async throws -> [TeamSummary]
	func createNewTeam(name: String) async throws -> Team
	func createNewPlace(name: String) async throws -> Place
	func createNewTeamPlace(name: String, teamId: Int) async throws -> Place
	func renamePlace(placeId: Int, newName: String) async throws -> Void
	func deletePlace(placeId: Int) async throws -> Void
	func fetchTeamMembers(teamId: Int) async throws -> [TeamMember]
	func renameTeam(teamId: Int, newName: String) async throws -> Void
	func deleteTeam(teamId: Int) async throws -> Void
	func fetchPlantEntry(plantEntryId: Int) async throws -> PlantEntry
	func addEvent(plantEntryId: Int, actionId: Int, date: Date) async throws -> Event
	func addReminder(plantEntryId: Int, actionId: Int, date: Date, period: Int) async throws -> Reminder
	func fetchUncompletedEvents() async throws -> [Event]
	func giveAdminRights(teamId: Int, userId: Int) async throws -> Void
	func removeAdminRights(teamId: Int, userId: Int) async throws -> Void
	func enableReminderNotifications(deviceId: String) async throws -> Void
	func disableReminderNotifications(deviceId: String) async throws -> Void
	func enableEventNotifications(deviceId: String) async throws -> Void
	func disableEventNotifications(deviceId: String) async throws -> Void
	func fetchUsers() async throws -> [User]
	func addTeamMember(teamId: Int, userId: Int) async throws -> Void
	func removeTeamMember(teamId: Int, memberId: Int) async throws -> Void
	func deleteReminder(reminderId: Int) async throws -> Void
	func deleteEvent(eventId: Int) async throws -> Void
	func editEvent(eventId: Int, actionId: Int, date: Date) async throws -> Event
	func editReminder(reminderId: Int, actionId: Int, date: Date, period: Int) async throws -> Reminder
	func createPicture(plantEntryId: Int, pictureUrl: URL) async throws -> Picture
	func deletePicture(pictureId: Int) async throws -> Void
	func addPlantEntry(name: String, headerPictureUrl: URL?, placeId: Int, plantId: Int) async throws -> CreatePlantEntryResponse
	func completeEvent(eventId: Int) async throws -> Void
	func addPushToken(pushToken: String, deviceId: String) async throws -> Void
	func setPlan(plantEntryId: Int, planId: Int, hour: Int, minute: Int) async throws -> Void
	func renamePlantEntry(plantEntryId: Int, newName: String) async throws -> Void
	func deletePlantEntry(plantEntryId: Int) async throws -> Void
	func fetchPlace(placeId: Int) async throws -> TeamSummaryPlace
	func deleteAccount(userId: Int) async throws -> Void
}

final class API : APIProtocol {
	#if DEBUG
	let baseUrl = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://localhost:3000"
	#else
	let baseUrl = "https://sprinkled-app.herokuapp.com"
	#endif
	
	func signIn(_ username: String, _ password: String, _ deviceId: String) async throws {
		let body = [
			"username": username,
			"password": password,
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		let response: AuthResponse = try await makeRequest(path: "auth/login", method: "POST", body: bodyData)
		UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
		UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
	}
	
	func signUp(_ username: String, _ email: String, _ password: String, _ deviceId: String) async throws {
		let body = [
			"username": username,
			"email": email,
			"password": password,
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		let response: AuthResponse = try await makeRequest(path: "auth/register", method: "POST", body: bodyData)
		UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
		UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
	}
	
	func logout(deviceId: String) async throws -> Void {
		let body = [
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "auth/logout", method: "POST", body: bodyData)
	}
	
	func fetchPlants() async throws -> [Plant] {
		return try await makeAuthenticatedRequest(path: "plants")
	}
	
	func fetchTeamSummaries() async throws -> [TeamSummary] {
		return try await makeAuthenticatedRequest(path: "teams/summary")
	}
	
	func createNewTeam(name: String) async throws -> Team {
		let body = [
			"name": name,
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "teams", method: "POST", body: bodyData)
	}
	
	func createNewPlace(name: String) async throws -> Place {
		let body = [
			"name": name,
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "places/user", method: "POST", body: bodyData)
	}
	
	func createNewTeamPlace(name: String, teamId: Int) async throws -> Place {
		let body: [String: Any] = [
			"name": name,
			"teamId": teamId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "places/team", method: "POST", body: bodyData)
	}
	
	func renamePlace(placeId: Int, newName: String) async throws -> Void {
		let body = [
			"name": newName
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "places/\(placeId)", method: "PUT", body: bodyData)
	}
	
	func deletePlace(placeId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "places/\(placeId)", method: "DELETE")
	}
	
	func fetchTeamMembers(teamId: Int) async throws -> [TeamMember] {
		return try await makeAuthenticatedRequest(path: "teams/\(teamId)/members")
	}
	
	func renameTeam(teamId: Int, newName: String) async throws {
		let body = [
			"name": newName
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "teams/\(teamId)", method: "PUT", body: bodyData)
	}
	
	func deleteTeam(teamId: Int) async throws {
		try await makeAuthenticatedRequest(path: "teams/\(teamId)", method: "DELETE")
	}
	
	func fetchPlantEntry(plantEntryId: Int) async throws -> PlantEntry {
		return try await makeAuthenticatedRequest(path: "plant-entries/\(plantEntryId)")
	}
	
	func addEvent(plantEntryId: Int, actionId: Int, date: Date) async throws -> Event {
		let body = [
			"plantEntryId": plantEntryId,
			"actionId": actionId,
			"date": date.encodeToStringForTransfer(),
		] as [String : Any]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "events", method: "POST", body: bodyData)
	}
	
	func addReminder(plantEntryId: Int, actionId: Int, date: Date, period: Int) async throws -> Reminder {
		let body = [
			"plantEntryId": plantEntryId,
			"actionId": actionId,
			"date": date.encodeToStringForTransfer(),
			"period": period
		] as [String : Any]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "reminders", method: "POST", body: bodyData)
	}
	
	func fetchUncompletedEvents() async throws -> [Event] {
		return try await makeAuthenticatedRequest(path: "events?completed=false")
	}
	
	func giveAdminRights(teamId: Int, userId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "teams/\(teamId)/members/\(userId)/give-admin-rights", method: "POST")
	}
	
	func removeAdminRights(teamId: Int, userId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "teams/\(teamId)/members/\(userId)/remove-admin-rights", method: "POST")
	}
	
	func enableReminderNotifications(deviceId: String) async throws -> Void {
		let body = [
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "notifications/enable-reminder-notifications", method: "POST", body: bodyData)
	}
	
	func disableReminderNotifications(deviceId: String) async throws -> Void {
		let body = [
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "notifications/disable-reminder-notifications", method: "POST", body: bodyData)
	}
	
	func enableEventNotifications(deviceId: String) async throws -> Void {
		let body = [
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "notifications/enable-event-notifications", method: "POST", body: bodyData)
	}
	
	func disableEventNotifications(deviceId: String) async throws -> Void {
		let body = [
			"deviceId": deviceId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "notifications/disable-event-notifications", method: "POST", body: bodyData)
	}
	
	func fetchUsers() async throws -> [User] {
		return try await makeAuthenticatedRequest(path: "users")
	}
	
	func addTeamMember(teamId: Int, userId: Int) async throws -> Void {
		let body = [
			"userId": userId
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "teams/\(teamId)/members", method: "POST", body: bodyData)
	}
	
	func removeTeamMember(teamId: Int, memberId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "teams/\(teamId)/members/\(memberId)", method: "DELETE")
	}
	
	func deleteReminder(reminderId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "reminders/\(reminderId)", method: "DELETE")
	}
	
	func deleteEvent(eventId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "events/\(eventId)", method: "DELETE")
	}
	
	func editEvent(eventId: Int, actionId: Int, date: Date) async throws -> Event {
		let body = [
			"actionId": actionId,
			"date": date.encodeToStringForTransfer(),
		] as [String : Any]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "events/\(eventId)", method: "PUT", body: bodyData)
	}
	
	func editReminder(reminderId: Int, actionId: Int, date: Date, period: Int) async throws -> Reminder {
		let body = [
			"actionId": actionId,
			"date": date.encodeToStringForTransfer(),
			"period": period
		] as [String : Any]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "reminders/\(reminderId)", method: "PUT", body: bodyData)
	}
	
	func createPicture(plantEntryId: Int, pictureUrl: URL) async throws -> Picture {
		let body = [
			"plantEntryId": plantEntryId,
			"url": pictureUrl.absoluteString
		] as [String : Any]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "pictures", method: "POST", body: bodyData)
	}
	
	func deletePicture(pictureId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "pictures/\(pictureId)", method: "DELETE")
	}
	
	func addPlantEntry(name: String, headerPictureUrl: URL?, placeId: Int, plantId: Int) async throws -> CreatePlantEntryResponse {
		var body = [
			"name": name,
			"placeId": placeId,
			"plantId": plantId
		] as [String : Any]
		if let headerPictureUrl {
			body["headerPictureUrl"] = headerPictureUrl.absoluteString
		}
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		return try await makeAuthenticatedRequest(path: "plant-entries", method: "POST", body: bodyData)
	}
	
	func completeEvent(eventId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "events/\(eventId)/complete", method: "POST")
	}
	
	func addPushToken(pushToken: String, deviceId: String) async throws -> Void {
		let body = [
			"pushToken": pushToken,
			"deviceId": deviceId
		] as [String : Any]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "notifications/addPushToken", method: "POST", body: bodyData)
	}
	
	func setPlan(plantEntryId: Int, planId: Int, hour: Int, minute: Int) async throws -> Void {
		let body = [
			"planId": planId,
			"preferredHour": hour,
			"preferredMinute": minute
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "plant-entries/\(plantEntryId)/setPlan", method: "POST", body: bodyData)
	}
	
	func renamePlantEntry(plantEntryId: Int, newName: String) async throws -> Void {
		let body = [
			"name": newName
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)
		try await makeAuthenticatedRequest(path: "plant-entries/\(plantEntryId)", method: "PUT", body: bodyData)
	}
	
	func deletePlantEntry(plantEntryId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "plant-entries/\(plantEntryId)", method: "DELETE")
	}
	
	func fetchPlace(placeId: Int) async throws -> TeamSummaryPlace {
		return try await makeAuthenticatedRequest(path: "places/\(placeId)")
	}
	
	func deleteAccount(userId: Int) async throws -> Void {
		try await makeAuthenticatedRequest(path: "users/\(userId)", method: "DELETE")
	}
		
	private func refreshToken() async throws {
		print("🔑", "Refreshing access token")
		let url = URL(string: "\(baseUrl)/auth/refresh")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let headers = request.allHTTPHeaderFields ?? [:]
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		request.allHTTPHeaderFields = headers.merging(["Authorization": "Bearer \(refreshToken)"], uniquingKeysWith: { $1 })
		
		
		let (data, response): (Data, URLResponse)
		
		do {
			(data, response) = try await performDataRequest(for: request)
		} catch APIError.cancelled {
			print("🚫 cancelled call to refresh token")
			return
		} catch {
			throw error
		}
		
		if ((response as? HTTPURLResponse)?.statusCode == 401) {
			if (refreshToken == UserDefaults.standard.string(forKey: "refreshToken")) {
				UserDefaults.standard.set("", forKey: "accessToken")
				UserDefaults.standard.set("", forKey: "refreshToken")
			}
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
			try await refreshToken()
		}
		
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		if (refreshToken.isEmpty) {
			throw APIError.expiredRefreshToken
		}

		var request = try prepareAuthenticatedRequest(path: path, query: query, method: method, body: body)
		let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
		let headers = request.allHTTPHeaderFields ?? [:]
		request.allHTTPHeaderFields = headers.merging(["Authorization": "Bearer \(accessToken)"], uniquingKeysWith: { $1 })
		let (data, _) = try await performDataRequest(for: request)
		
		return try JSONDecoder.app.decode(Response.self, from: data)
	}
	
	private func makeAuthenticatedRequest(
		path: String,
		query: [URLQueryItem] = [],
		method: String? = nil,
		body: Data? = nil
	) async throws {
		if (!isTokenValid(UserDefaults.standard.string(forKey: "accessToken"))) {
			try await refreshToken()
		}
		
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		if (refreshToken.isEmpty) {
			throw APIError.expiredRefreshToken
		}

		var request = try prepareAuthenticatedRequest(path: path, query: query, method: method, body: body)
		let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
		let headers = request.allHTTPHeaderFields ?? [:]
		request.allHTTPHeaderFields = headers.merging(["Authorization": "Bearer \(accessToken)"], uniquingKeysWith: { $1 })
		_ = try await performDataRequest(for: request)
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
		
		guard let url = components?.url else { throw APIError.invalidURL }
		
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
		print("⬆️", request.url!.absoluteString, "[", request.httpMethod ?? "GET", "]")
		//		if let body = request.httpBody {
		//			print("BODY:", String(data: body, encoding: .utf8)!)
		//		}
		var (data, response): (Data, URLResponse)
		do {
			(data, response) = try await URLSession.shared.data(for: request)
		} catch {
			guard let errorCode = (error as? URLError)?.code else {
				throw APIError.unknown
			}
			switch (errorCode) {
			case .cancelled:
				throw APIError.cancelled
			case .notConnectedToInternet, .dataNotAllowed, .networkConnectionLost:
				throw APIError.connectionFailed
			default:
				print(error)
				throw APIError.unknown
			}
		}
		
		print("⬇️", request.url!.absoluteString, "[", (response as? HTTPURLResponse)?.statusCode ?? 0, "]")
		//		print(String(data: data, encoding: .utf8)!)
		
		guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
			throw APIError.unknown
		}
		
		if (statusCode == 400 || statusCode == 403) {
			let errorResponse = try JSONDecoder.app.decode(ErrorResponse.self, from: data)
			throw APIError.errorResponse(descriptions: errorResponse.descriptions)
		}
		
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
	func signIn(_ username: String, _ password: String, _ deviceId: String) async throws {
		return
	}
	
	func signUp(_ username: String, _ email: String, _ password: String, _ deviceId: String) async throws {
		return
	}
	
	func logout(deviceId: String) async throws -> Void {
		return
	}
	
	func fetchPlants() async throws -> [Plant] {
		return TestData.plants
	}
	
	func fetchTeamSummaries() async throws -> [TeamSummary] {
		return TestData.teamSummaries
	}
	
	func createNewTeam(name: String) async throws -> Team {
		return Team(id: 1, name: name)
	}
	
	func createNewPlace(name: String) async throws -> Place {
		return Place(id: 1, name: name, teamId: nil, userId: 1)
	}
	
	func createNewTeamPlace(name: String, teamId: Int) async throws -> Place {
		return Place(id: 1, name: name, teamId: 1, userId: nil)
	}
	
	func renamePlace(placeId: Int, newName: String) async throws -> Void {
		return
	}
	
	func deletePlace(placeId: Int) async throws -> Void {
		return
	}
	
	func fetchTeamMembers(teamId: Int) async throws -> [TeamMember] {
		return TestData.teamMembers
	}
	
	func renameTeam(teamId: Int, newName: String) async throws {
		return
	}
	
	func deleteTeam(teamId: Int) async throws {
		return
	}
	
	func fetchPlantEntry(plantEntryId: Int) async throws -> PlantEntry {
		return TestData.plantEntries[0]
	}
	
	func addEvent(plantEntryId: Int, actionId: Int, date: Date) async throws -> Event {
		return TestData.events[0]
	}
	
	func addReminder(plantEntryId: Int, actionId: Int, date: Date, period: Int) async throws -> Reminder {
		return TestData.reminders[0]
	}
	
	func fetchUncompletedEvents() async throws -> [Event] {
		return TestData.events.filter({!$0.completed})
	}
	
	func giveAdminRights(teamId: Int, userId: Int) async throws -> Void {
		return
	}
	
	func removeAdminRights(teamId: Int, userId: Int) async throws -> Void {
		return
	}
	
	func enableReminderNotifications(deviceId: String) async throws -> Void {
		return
	}
	
	func disableReminderNotifications(deviceId: String) async throws -> Void {
		return
	}
	
	func enableEventNotifications(deviceId: String) async throws -> Void {
		return
	}
	
	func disableEventNotifications(deviceId: String) async throws -> Void {
		return
	}
	
	func fetchUsers() async throws -> [User] {
		return TestData.users
	}
	
	func addTeamMember(teamId: Int, userId: Int) async throws -> Void {
		return
	}
	
	func removeTeamMember(teamId: Int, memberId: Int) async throws -> Void {
		return
	}
	
	func deleteReminder(reminderId: Int) async throws -> Void {
		return
	}
	
	func deleteEvent(eventId: Int) async throws -> Void {
		return
	}
	
	func editEvent(eventId: Int, actionId: Int, date: Date) async throws -> Event {
		return TestData.events[0]
	}
	
	func editReminder(reminderId: Int, actionId: Int, date: Date, period: Int) async throws -> Reminder {
		return TestData.reminders[0]
	}
	
	func createPicture(plantEntryId: Int, pictureUrl: URL) async throws -> Picture {
		return TestData.pictures[0]
	}
	
	func deletePicture(pictureId: Int) async throws -> Void {
		return
	}
	
	func addPlantEntry(name: String, headerPictureUrl: URL?, placeId: Int, plantId: Int) async throws -> CreatePlantEntryResponse {
		return CreatePlantEntryResponse(id: 1, name: "Plant Entry 1", createdAt: Date(), creatorId: 1, placeId: 1, plantId: 1, headerPictureUrl: nil)
	}
	
	func completeEvent(eventId: Int) async throws -> Void {
		return
	}
	
	func addPushToken(pushToken: String, deviceId: String) async throws -> Void {
		return
	}
	
	func setPlan(plantEntryId: Int, planId: Int, hour: Int, minute: Int) async throws -> Void {
		return
	}
	
	func renamePlantEntry(plantEntryId: Int, newName: String) async throws -> Void {
		return
	}
	
	func deletePlantEntry(plantEntryId: Int) async throws -> Void {
		return
	}
	
	func fetchPlace(placeId: Int) async throws -> TeamSummaryPlace {
		return TestData.teamSummaries[0].places[0]
	}
	
	func deleteAccount(userId: Int) async throws -> Void {
		return
	}
}
