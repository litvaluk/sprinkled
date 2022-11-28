import SwiftUI

struct CreatePlaceView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: CreatePlaceViewModel
	
	var body: some View {
		VStack {
			TextField("Name", text: $vm.placeName)
				.textFieldStyle(SprinkledTextFieldStyle())
				.autocorrectionDisabled()
			Menu {
				Picker(selection: $vm.teamSelection, label: EmptyView()) {
					ForEach(vm.teamSummaries) { teamSummary in
						Text(teamSummary.name)
							.tag(teamSummary.id)
					}
				}
			} label: {
				HStack {
					Text("Team")
						.foregroundColor(.primary)
					Spacer()
					Text(vm.teamSummaries.first(where: { $0.id == vm.teamSelection })!.name)
						.foregroundColor(.gray)
					Image(systemName: "chevron.up.chevron.down")
						.resizable()
						.scaledToFit()
						.frame(width: 10, height: 10)
						.fontWeight(.semibold)
						.foregroundColor(.gray)
						.padding(.leading, 4)
				}
				.padding(15)
				.background(.thinMaterial)
				.cornerRadius(10)
			}
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
						if (await vm.createNewPlace()) {
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
		.navigationTitle("Create new place")
	}
}

struct CreatePlaceView_Previews: PreviewProvider {
	static var previews: some View {
		CreatePlaceView(vm: CreatePlaceViewModel(teamSummaries: TestData.teamSummaries, teamSelection: 0, errorPopupsState: ErrorPopupsState()))
	}
}
