import SwiftUI

@main
struct SprinkledApp: App {
	init() {
		UITabBar.appearance().unselectedItemTintColor = .label
		UITabBar.appearance().tintColor = .label
	}
	
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
        }
    }
}
