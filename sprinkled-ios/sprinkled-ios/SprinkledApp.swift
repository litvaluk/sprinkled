import SwiftUI
import UIKit
import JWTDecode

@main
struct SprinkledApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	init() {
		UITabBar.appearance().unselectedItemTintColor = .label
		
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		if (!refreshToken.isEmpty && (try! decode(jwt: refreshToken).expired)) {
			UserDefaults.standard.set("", forKey: "accessToken")
			UserDefaults.standard.set("", forKey: "refreshToken")
		}
	}
	
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
        }
    }
}
