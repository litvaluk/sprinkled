import SwiftUI

struct AddReminderView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: AddReminderViewModel
	
	var body: some View {
		VStack {
			HStack {
				Text(vm.plantEntryName)
					.fontWeight(.medium)
					.font(.title2)
				Spacer()
			}
			SprinkledListMenuPicker(title: "For action", options: vm.actions.map{$0.type}, selection: $vm.actionSelection)
			SprinkledListToggle(title: "Repeating", isOn: $vm.repeating.animation(.easeInOut(duration: 0.2)))
			if(vm.repeating) {
				VStack(spacing: 0) {
					Button {
						withAnimation(.easeInOut(duration: 0.2)) {
							vm.periodPickerOpen.toggle()
						}
					} label: {
						HStack {
							Text("Period (days)")
								.foregroundColor(.primary)
							Spacer()
							Text("\(vm.period)")
								.foregroundColor(.gray)
							Image(systemName: vm.periodPickerOpen ? "chevron.down" : "chevron.right")
								.resizable()
								.scaledToFit()
								.frame(width: 10, height: 10)
								.fontWeight(.semibold)
								.foregroundColor(.gray)
								.padding(.leading, 4)
						}
						.padding(15)
					}
					if (vm.periodPickerOpen) {
						Picker(selection: $vm.period, label: EmptyView()) {
							ForEach(1..<100) { i in
								Text("\(i)")
									.tag(i)
							}
						}
						.pickerStyle(.wheel)
					}
				}
				.background(.thinMaterial)
				.cornerRadius(10)
			}
			
			SprinkledListDatePicker(title: vm.repeating ? "Starting date" : "Date", selection: $vm.date, displayedComponents: .date)
			SprinkledListDatePicker(title: vm.repeating ? "Starting time" : "Time", selection: $vm.date, displayedComponents: .hourAndMinute)
			Spacer()
			if (vm.isProcessing) {
				ProgressView()
					.scaleEffect(1.5)
					.padding()
			} else {
				Button {
					Task {
						if (await vm.addNewReminder()) {
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
		.navigationTitle("Add new reminder")
	}
}

struct AddReminderView_Previews: PreviewProvider {
	static var previews: some View {
		AddReminderView(vm: AddReminderViewModel(plantEntryId: 1, plantEntryName: "Plant entry 1", errorPopupsState: ErrorPopupsState()))
	}
}
