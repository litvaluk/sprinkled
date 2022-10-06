import SwiftUI

struct RootView: View {
	@StateObject var viewModel: RootViewModel
	
    var body: some View {
		Group {
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
				SearchView().tabItem {
					if (viewModel.tabBarSelection == 2) {
						Image("SearchViewIconSelected")
					} else {
						Image("SearchViewIcon")
					}
				}.tag(2)
				ProfileView().tabItem {
					if (viewModel.tabBarSelection == 3) {
						Image("ProfileViewIconSelected")
					} else {
						Image("ProfileViewIcon")
					}
				}
				.tag(3)
			}
			.accentColor(Color(.label))
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
