import SwiftUI
import UIKit

@main
struct SprinkledApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	init() {
		UITabBar.appearance().unselectedItemTintColor = .label
	}
	
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel(dependencies: dependencies))
        }
    }
}
