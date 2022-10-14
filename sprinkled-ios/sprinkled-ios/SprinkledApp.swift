import SwiftUI

@main
struct SprinkledApp: App {
	init() {
		UITabBar.appearance().unselectedItemTintColor = .label
	}
	
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel(dependencies: dependencies))
        }
    }
}
