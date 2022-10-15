import SwiftUI

struct RootView: View {
	@Environment(\.scenePhase) var scenePhase
	
	@StateObject var viewModel: RootViewModel
	
    var body: some View {
		if (!viewModel.accessToken.isEmpty) {
			TabView(selection: $viewModel.tabBarSelection) {
				TaskView().tabItem {
					if (viewModel.tabBarSelection == 0) {
						Image("TaskViewIconSelected")
					} else {
						Image("TaskViewIcon")
					}
				}.tag(0)
				MyPlantsView().tabItem {
					if (viewModel.tabBarSelection == 1) {
						Image("MyPlantsViewIconSelected")
					} else {
						Image("MyPlantsViewIcon")
					}
				}.tag(1)
				SearchView(viewModel: SearchViewModel(dependencies: dependencies)).tabItem {
					if (viewModel.tabBarSelection == 2) {
						Image("SearchViewIconSelected")
					} else {
						Image("SearchViewIcon")
					}
				}.tag(2)
				ProfileView(viewModel: ProfileViewModel(dependencies: dependencies)).tabItem {
					if (viewModel.tabBarSelection == 3) {
						Image("ProfileViewIconSelected")
					} else {
						Image("ProfileViewIcon")
					}
				}
				.tag(3)
			}
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
