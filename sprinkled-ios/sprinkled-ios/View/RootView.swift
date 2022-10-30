import SwiftUI

struct RootView: View {
	@Environment(\.scenePhase) var scenePhase
	
	@StateObject var viewModel: RootViewModel
	@StateObject var tabBarState = TabBarState()
	@StateObject var pictureViewState = PictureViewState()
	
	var body: some View {
		if (!viewModel.accessToken.isEmpty) {
			ZStack {
				TabView(selection: tabBarState.handler) {
					TaskView(vm: TaskViewModel())
						.tabItem {
							if (tabBarState.selection == 0) {
								Image("TaskViewIconSelected")
							} else {
								Image("TaskViewIcon")
							}
						}.tag(0)
					MyPlantsView(viewModel: MyPlantsViewModel())
						.tabItem {
							if (tabBarState.selection == 1) {
								Image("MyPlantsViewIconSelected")
							} else {
								Image("MyPlantsViewIcon")
							}
						}.tag(1)
					SearchView(viewModel: SearchViewModel())
						.tabItem {
							if (tabBarState.selection == 2) {
								Image("SearchViewIconSelected")
							} else {
								Image("SearchViewIcon")
							}
						}.tag(2)
					ProfileView(viewModel: ProfileViewModel())
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
				PictureView()
					.zIndex(1)
			}
			.environmentObject(pictureViewState)
		} else {
			AuthView(viewModel: AuthViewModel())
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(viewModel: RootViewModel())
	}
}
