import SwiftUI

struct CreateTeamView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: CreateTeamViewModel
	
	var body: some View {
		VStack {
			TextField("Name", text: $vm.teamName)
				.textFieldStyle(SprinkledTextFieldStyle())
				.autocorrectionDisabled()
			if (!vm.errorMessage.isEmpty) {
				Text("\(vm.errorMessage)")
					.multilineTextAlignment(.center)
					.foregroundColor(.red)
			}
			Spacer()
			if (vm.isProcessing) {
				ProgressView()
					.scaleEffect(1.5)
					.padding()
			} else {
				Button {
					Task {
						if (await vm.createNewTeam()) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				} label: {
					Text("Create")
						.frame(maxWidth: .infinity, minHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
			}
		}
		.padding()
		.navigationTitle("Create new team")
	}
}

struct CreateTeamView_Previews: PreviewProvider {
	static var previews: some View {
		CreateTeamView(vm: CreateTeamViewModel(errorPopupsState: ErrorPopupsState()))
	}
}
