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
			Menu {
				Picker(selection: $vm.actionSelection, label: EmptyView()) {
					ForEach(vm.actions) { action in
						Text(action.type)
							.tag(action.id)
					}
				}
			} label: {
				HStack {
					Text("Action")
						.foregroundColor(.primary)
					Spacer()
					Text(vm.actions.first(where: { $0.id == vm.actionSelection })!.type)
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
			DateItemView(title: "Date", selection: $vm.date, displayedComponents: .date)
			DateItemView(title: "Time", selection: $vm.date, displayedComponents: .hourAndMinute)
			if !vm.errorMessage.isEmpty {
				Text("\(vm.errorMessage)")
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

struct DateItemView: View {
	let title: String
	let selection: Binding<Date>
	let displayedComponents: DatePicker.Components
	
	var body: some View {
		ZStack {
			HStack {
				Text(title)
					.foregroundColor(.primary)
					.padding(.vertical, 15)
				Spacer()
				DatePicker("Pick date", selection: selection, displayedComponents: displayedComponents)
					.datePickerStyle(.compact)
					.labelsHidden()
					.padding(.trailing, 8)
			}
			.padding(.leading, 15)
			.background(.thinMaterial)
			.cornerRadius(10)
		}
	}
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
		AddEventView(vm: AddEventViewModel(plantEntryId: 1, plantEntryName: "Plant entry 1"))
    }
}
