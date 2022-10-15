import Foundation
import SwiftUI
import JWTDecode

final class RootViewModel: ObservableObject {
	@StateObject var tabBarState = TabBarState()

	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
}
