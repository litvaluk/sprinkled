import SwiftUI
import PopupView

struct RootView: View {
	@StateObject var vm: RootViewModel
	@StateObject var tabBarState = TabBarState()
	@StateObject var errorPopupsState: ErrorPopupsState
	@StateObject var pictureViewState: PictureViewState
	@AppStorage("showOnboarding") var showOnboarding: Bool = false
	
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
						.padding(.bottom, 45)
						.tag(0)
						.ignoresSafeArea(.keyboard, edges: .bottom)
					MyPlantsView(viewModel: MyPlantsViewModel(errorPopupsState: errorPopupsState))
						.padding(.bottom, 45)
						.tag(1)
						.ignoresSafeArea(.keyboard, edges: .bottom)
					SearchView(viewModel: SearchViewModel(errorPopupsState: errorPopupsState))
						.padding(.bottom, 45)
						.tag(2)
						.ignoresSafeArea(.keyboard, edges: .bottom)
					ProfileView(vm: ProfileViewModel(errorPopupsState: errorPopupsState, tabBarState: tabBarState))
						.padding(.bottom, 45)
						.tag(3)
						.ignoresSafeArea(.keyboard, edges: .bottom)
				}
				.environmentObject(tabBarState)
				TabBarView()
					.environmentObject(tabBarState)
				PictureView()
					.zIndex(1)
			}
			.ignoresSafeArea(.keyboard, edges: .bottom)
			.popup(isPresented: $errorPopupsState.showConnectionError, type: .floater(verticalPadding: 70), position: .bottom, animation: .spring().speed(2), autohideIn: 3) {
				ConnectionErrorPopupView()
			}
			.popup(isPresented: $errorPopupsState.showGenericError, type: .floater(verticalPadding: 70), position: .bottom, animation: .spring().speed(2), autohideIn: 3) {
				GenericErrorPopupView()
			}
			.popup(isPresented: $errorPopupsState.showSuccess, type: .floater(verticalPadding: 70), position: .bottom, animation: .spring().speed(2), autohideIn: 3) {
				SuccessPopupView(text: errorPopupsState.successPopupText)
			}
			.fullScreenCover(isPresented: $showOnboarding) {
				OnboardingView(vm: OnboardingViewModel())
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
