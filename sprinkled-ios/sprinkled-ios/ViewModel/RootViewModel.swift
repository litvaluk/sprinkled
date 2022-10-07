import Foundation
import SwiftUI

final class RootViewModel: ObservableObject {

	@Published var tabBarSelection = 0
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	
}

