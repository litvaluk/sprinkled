import SwiftUI
import PopupView

struct RootView: View {
	@StateObject var vm: RootViewModel
	@StateObject var tabBarState = TabBarState()
	@StateObject var errorPopupsState: ErrorPopupsState
	@StateObject var pictureViewState: PictureViewState
	
	init(vm: RootViewModel) {
		self._vm = StateObject(wrappedValue: vm)
		let errorPopupsState = ErrorPopupsState()
		self._errorPopupsState = StateObject(wrappedValue: errorPopupsState)
		self._pictureViewState = StateObject(wrappedValue: PictureViewState(errorPopupsState: errorPopupsState))
	}
	
	var body: some View {
		if (!vm.accessToken.isEmpty) {
			ZStack(alignment: .bottom) {
				TabView(selection: $tabBarState.selection) {
					TaskView(vm: TaskViewModel(errorPopupsState: errorPopupsState))
						.padding(.bottom, 47)
						.tag(0)
					MyPlantsView(viewModel: MyPlantsViewModel(errorPopupsState: errorPopupsState))
						.padding(.bottom, 47)
						.tag(1)
					SearchView(viewModel: SearchViewModel(errorPopupsState: errorPopupsState))
						.padding(.bottom, 47)
						.tag(2)
					ProfileView(vm: ProfileViewModel(errorPopupsState: errorPopupsState))
						.padding(.bottom, 47)
						.tag(3)
				}
				.environmentObject(tabBarState)
				TabBarView()
					.environmentObject(tabBarState)
				PictureView()
					.zIndex(1)
			}
			.popup(isPresented: $errorPopupsState.showConnectionError, type: .floater(verticalPadding: 70), position: .bottom, animation: .spring().speed(2), autohideIn: 5) {
				ConnectionErrorPopupView()
			}
			.popup(isPresented: $errorPopupsState.showGenericError, type: .floater(verticalPadding: 70), position: .bottom, animation: .spring().speed(2), autohideIn: 5) {
				GenericErrorPopupView()
			}
			.environmentObject(pictureViewState)
			.environmentObject(errorPopupsState)
		} else {
			AuthView(viewModel: AuthViewModel())
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(vm: RootViewModel())
	}
}
