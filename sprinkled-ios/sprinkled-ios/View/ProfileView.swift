import SwiftUI

struct ProfileView: View {
	@StateObject var vm: ProfileViewModel
	@AppStorage("showOnboarding") var showOnboarding: Bool = false
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				SprinkledListSection(headerText: "Notifications") {
					SprinkledListToggle(title: "Reminder notifications", isOn: $vm.reminderNotificationsEnabled)
						.onChange(of: vm.reminderNotificationsEnabled) { _ in
							Task {
								await vm.onReminderNotificationsToggleChange()
							}
						}
					SprinkledListToggle(title: "Event notifications", isOn: $vm.eventNotificationsEnabled)
						.onChange(of: vm.eventNotificationsEnabled) { _ in
							Task {
								await vm.onEventNotificationsToggleChange()
							}
						}
				}
				SprinkledListSection(headerText: "Other") {
					SprinkledListMenuPicker(title: "Unit system", options: ["Metric", "Imperial"], selection: $vm.unitSystem)
				}
				SprinkledListSection(headerText: "Tutorial") {
					Button {
						showOnboarding = true
					} label: {
						HStack {
							Spacer()
							Text("Show tutorial")
								.foregroundColor(.sprinkledGreen)
							Spacer()
						}
						.padding(15)
						.background(.thinMaterial)
						.cornerRadius(10)
					}
				}
				Spacer()
				Button(role: .destructive) {
					vm.logout()
				} label: {
					HStack {
						Spacer()
						Text("Sign out")
							.foregroundColor(.red)
						Spacer()
					}
					.padding(15)
					.background(.thinMaterial)
					.cornerRadius(10)
				}
			}
			.padding()
			.navigationTitle(vm.getAuthenticatedUser()?.capitalizedFirstLetter() ?? "Profile")
		}
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView(vm: ProfileViewModel(errorPopupsState: ErrorPopupsState(), tabBarState: TabBarState()))
	}
}
