import SwiftUI

struct EditEventView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: EditEventViewModel
	
	var body: some View {
		VStack {
			HStack {
				Text(vm.plantEntryName)
					.fontWeight(.medium)
					.font(.title2)
				Spacer()
			}
			SprinkledListMenuPicker(title: "Action", options: vm.actions.map{$0.type}, selection: $vm.actionSelection)
			SprinkledListDatePicker(title: "Date", selection: $vm.date, displayedComponents: .date)
			SprinkledListDatePicker(title: "Time", selection: $vm.date, displayedComponents: .hourAndMinute)
			Spacer()
			if (vm.isProcessing) {
				ProgressView()
					.scaleEffect(1.5)
					.padding()
			} else {
				Button {
					Task {
						if (await vm.editEvent()) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				} label: {
					Text("Edit")
						.frame(maxWidth: .infinity, minHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
			}
		}
		.padding(.horizontal)
		.padding(.bottom)
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle("Edit event")
	}
}

struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
		EditEventView(vm: EditEventViewModel(plantEntryId: 1, plantEntryName: "Plant entry 1", event: TestData.events[0], errorPopupsState: ErrorPopupsState()))
    }
}
