import SwiftUI

struct ProfileView: View {
	@StateObject var viewModel: ProfileViewModel
	
	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Credentials")) {
					Button("Change username") {}
					Button("Change password") {}
				}
				Section(header: Text("Notifications")) {
					Toggle("Reminder notifications", isOn: $viewModel.reminderNotificationsEnabled)
						.onChange(of: viewModel.reminderNotificationsEnabled) { _ in
						   viewModel.onReminderNotificationsToggleChange()
					   }
					Toggle("Event notifications", isOn: $viewModel.eventNotificationsEnabled)
						.onChange(of: viewModel.eventNotificationsEnabled) { _ in
						   viewModel.onEventNotificationsToggleChange()
					   }
				}
				Section(header: Text("Other")) {
					Picker("Unit system", selection: $viewModel.unitSystemSelection) {
						Text("Metric").tag(0)
						Text("Imperial").tag(1)
					}
					.pickerStyle(.automatic)
				}
				HStack {
					Spacer()
					Button("Sign Out", role: .destructive) {
						viewModel.logout()
					}
					Spacer()
				}
				
			}
			.tint(.sprinkledGreen)
			.navigationTitle(viewModel.getAuthenticatedUser()?.capitalizedFirstLetter() ?? "Profile")
		}
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView(viewModel: ProfileViewModel())
	}
}
