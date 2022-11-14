import SwiftUI

struct AddEventView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: AddEventViewModel
	
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
						if (await vm.addNewEvent()) {
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
		.padding(.horizontal)
		.padding(.bottom)
		.navigationTitle("Add new event")
    }
}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
		AddEventView(vm: AddEventViewModel(plantEntryId: 1, plantEntryName: "Plant entry 1", errorPopupsState: ErrorPopupsState()))
    }
}
