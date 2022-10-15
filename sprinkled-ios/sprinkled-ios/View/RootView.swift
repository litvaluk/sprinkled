import SwiftUI

struct RootView: View {
	@Environment(\.scenePhase) var scenePhase
	
	@StateObject var viewModel: RootViewModel
	@StateObject var tabBarState = TabBarState()
	
	var body: some View {
		if (!viewModel.accessToken.isEmpty) {
			TabView(selection: tabBarState.handler) {
				TaskView()
					.tabItem {
						if (tabBarState.selection == 0) {
							Image("TaskViewIconSelected")
						} else {
							Image("TaskViewIcon")
						}
					}.tag(0)
				MyPlantsView()
					.tabItem {
						if (tabBarState.selection == 1) {
							Image("MyPlantsViewIconSelected")
						} else {
							Image("MyPlantsViewIcon")
						}
					}.tag(1)
				SearchView(viewModel: SearchViewModel(dependencies: dependencies))
					.tabItem {
						if (tabBarState.selection == 2) {
							Image("SearchViewIconSelected")
						} else {
							Image("SearchViewIcon")
						}
					}.tag(2)
				ProfileView(viewModel: ProfileViewModel(dependencies: dependencies))
					.tabItem {
						if (tabBarState.selection == 3) {
							Image("ProfileViewIconSelected")
						} else {
							Image("ProfileViewIcon")
						}
					}
					.tag(3)
			}
			.environmentObject(tabBarState)
		} else {
			AuthView(viewModel: AuthViewModel(dependencies: dependencies))
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(viewModel: RootViewModel())
	}
}
