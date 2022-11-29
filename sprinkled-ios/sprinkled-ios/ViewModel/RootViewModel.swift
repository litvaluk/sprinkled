import Foundation
import SwiftUI

final class RootViewModel: ObservableObject {
	@StateObject var tabBarState = TabBarState()

	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	@AppStorage("showOnboarding") var showOnboarding: Bool = false
}
