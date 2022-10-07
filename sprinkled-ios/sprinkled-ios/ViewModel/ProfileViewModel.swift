import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
	func logout() {
		accessToken = ""
		refreshToken = ""
	}
}
