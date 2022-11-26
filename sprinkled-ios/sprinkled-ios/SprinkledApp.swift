import SwiftUI
import UIKit
import JWTDecode
import FirebaseCore

@main
struct SprinkledApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	init() {
		UITabBar.appearance().isHidden = true
		
		let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
		if (!refreshToken.isEmpty && (try! decode(jwt: refreshToken).expired)) {
			UserDefaults.standard.set("", forKey: "accessToken")
			UserDefaults.standard.set("", forKey: "refreshToken")
		}
		
		DispatchQueue.main.async {
			UIApplication.shared.registerForRemoteNotifications()
		}
	}
	
	var body: some Scene {
		WindowGroup {
			RootView(vm: RootViewModel())
		}
	}
}
