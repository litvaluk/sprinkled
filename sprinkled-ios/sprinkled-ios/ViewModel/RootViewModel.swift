import Foundation
import SwiftUI
import JWTDecode

final class RootViewModel: ObservableObject {
	@Published var tabBarSelection = 0
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
	typealias Dependencies = HasAPI
	private let dependencies: Dependencies

	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func refreshTokenIfNeeded() async {
		var decodedAccessToken = try! decode(jwt: accessToken)
		if (decodedAccessToken.expired) {
			await dependencies.api.refreshToken()
		}
	}
}

