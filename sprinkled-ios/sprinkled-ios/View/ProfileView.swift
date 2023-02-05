import SwiftUI

struct ProfileView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: ProfileViewModel
	
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
					Button {
						withAnimation(.easeOut(duration: 0.07)) {
							vm.showDeleteAccountModal = true
						}
					} label: {
						destructionButtonLabel("Delete account")
					}
				}
				Spacer()
				Button {
					vm.logout()
				} label: {
					destructionButtonLabel("Sign Out")
				}
			}
			.padding()
			.navigationTitle(vm.getAuthenticatedUser()?.capitalizedFirstLetter() ?? "Profile")
		}
		.modal(title: "Are you sure?", showModal: $vm.showDeleteAccountModal) {
			Text("You will lose all personal places, plant entries and will be removed from all teams you are member of.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await vm.deleteAccount()) {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				}
			} label: {
				Text("Delete")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.tint(.sprinkledRed)
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.showDeleteAccountModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
	}
	
	func destructionButtonLabel(_ text: String) -> some View {
		HStack {
			Spacer()
			Text(text)
				.foregroundColor(.sprinkledRed)
			Spacer()
		}
		.padding(15)
		.background(.thinMaterial)
		.cornerRadius(10)
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView(vm: ProfileViewModel(errorPopupsState: ErrorPopupsState(), tabBarState: TabBarState()))
	}
}
