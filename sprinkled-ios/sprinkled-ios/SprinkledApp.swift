import SwiftUI
import UIKit
import JWTDecode

@main
struct SprinkledApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	@Provider var api = API() as APIProtocol
	@Provider var notificationManager = NotificationManager() as NotificationManagerProtocol
	
	init() {
		let appearance = UITabBarAppearance()
		let itemAppearance = UITabBarItemAppearance()
		itemAppearance.normal.iconColor = UIColor(Color.primary)
		itemAppearance.selected.iconColor = UIColor(Color.sprinkledGreen)
		appearance.inlineLayoutAppearance = itemAppearance
		appearance.stackedLayoutAppearance = itemAppearance
		appearance.compactInlineLayoutAppearance = itemAppearance
		UITabBar.appearance().scrollEdgeAppearance = appearance
		UITabBar.appearance().standardAppearance = appearance
		
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
