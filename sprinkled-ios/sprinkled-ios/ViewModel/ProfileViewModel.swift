import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
	@AppStorage("accessTokenValue") var accessTokenValue = ""
	@AppStorage("refreshTokenValue") var refreshTokenValue = ""
	
	func logout() {
		accessTokenValue = ""
		refreshTokenValue = ""
	}
}
