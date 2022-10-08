import Foundation
import SwiftUI
import JWTDecode

final class ProfileViewModel: ObservableObject {
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
	@Published var unitSystemSelection = 0
	@Published var reminderNotificationsEnabled = false
	@Published var eventNotificationsEnabled = false
	
	func logout() {
		accessToken = ""
		refreshToken = ""
	}
	
	func getAuthenticatedUser() -> String? {
		return try? decode(jwt: accessToken).claim(name: "username").string
	}
}
