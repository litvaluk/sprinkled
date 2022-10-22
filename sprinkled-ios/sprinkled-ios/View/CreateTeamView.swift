import SwiftUI

struct CreateTeamView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var viewModel: CreateTeamViewModel
	
    var body: some View {
		VStack {
			TextField("Name", text: $viewModel.teamName)
				.textFieldStyle(SprinkledTextFieldStyle())
				.autocorrectionDisabled()
				.textInputAutocapitalization(.never)
			if !viewModel.errorMessage.isEmpty {
				Text("\(viewModel.errorMessage)")
					.foregroundColor(.red)
			}
			Spacer()
			if (viewModel.isProcessing) {
				ProgressView()
					.scaleEffect(1.5)
					.padding()
			} else {
				Button {
					Task {
						if (await viewModel.createNewTeam()) {
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
        CreateTeamView(viewModel: CreateTeamViewModel())
    }
}
