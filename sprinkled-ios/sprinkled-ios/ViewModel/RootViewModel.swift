import Foundation
import SwiftUI
import JWTDecode

final class RootViewModel: ObservableObject {
	@Published var tabBarSelection = 0
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
}

