import Foundation
import SwiftUI

final class RootViewModel: ObservableObject {

	@Published var tabBarSelection = 0
	
	@AppStorage("accessTokenValue") var accessTokenValue = ""
	@AppStorage("refreshTokenValue") var refreshTokenValue = ""
	
}

