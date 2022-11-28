import SwiftUI

struct SetPlanView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: SetPlanViewModel
	
	var body: some View {
		VStack(alignment: .center) {
			HStack(spacing: 0) {
				Spacer()
				Button {
					presentationMode.wrappedValue.dismiss()
				} label: {
					Text("Skip")
						.font(.title3)
				}
			}
			ScrollView {
				HStack(spacing: 0) {
					Text("Set reminder plan")
						.font(.largeTitle)
						.fontWeight(.bold)
					Spacer()
				}
				.padding(.top, 4)
				HStack(spacing: 0) {
					Text("\(vm.plantEntryName)")
						.font(.title2)
					Spacer()
				}
				Text("You can choose from one of our recommended reminder plans or set reminders later manually (tap “Skip”)")
					.font(.callout)
					.multilineTextAlignment(.center)
					.foregroundColor(.secondary)
					.padding(.vertical)
				SprinkledListDatePicker(title: "Reminder time", selection: $vm.reminderTime, displayedComponents: .hourAndMinute)
				ForEach(vm.plans) { plan in
					HStack(alignment: .center) {
						VStack(alignment: .leading, spacing: 4) {
							Text("\(plan.name)")
								.font(.title3)
								.padding(.bottom, 6)
							ForEach(plan.reminderBlueprints) { rb in
								HStack(alignment: .center) {
									Circle()
										.frame(width: 7)
										.foregroundColor(.secondary)
									Text("\(rb.action.type) every \(rb.period) days")
										.foregroundColor(.secondary)
								}
							}
						}
						.padding()
						Spacer()
						if (vm.planSelection == plan.id) {
							Circle()
								.fill(Color.sprinkledGreen)
								.frame(width: 22)
								.overlay {
									Image(systemName: "checkmark")
										.resizable()
										.foregroundColor(.white)
										.fontWeight(.heavy)
										.padding(6)
								}
								.padding()
						} else {
							Circle()
								.strokeBorder(Color.sprinkledGreen, lineWidth: 2)
								.frame(width: 22)
								.padding()
						}
					}
					.background(.thinMaterial)
					.cornerRadius(10)
					.onTapGesture {
						withAnimation(.easeInOut(duration: 0.08)) {
							vm.planSelection = plan.id
						}
					}
				}
			}
			SprinkledButton(text: "Set") {
				Task {
					if (await vm.setPlan()) {
						presentationMode.wrappedValue.dismiss()
					}
				}
			}
		}
		.padding()
	}
}

struct SetPlanView_Previews: PreviewProvider {
	static var previews: some View {
		SetPlanView(vm: SetPlanViewModel(plantEntryId: TestData.plantEntries[0].id, plantEntryName: TestData.plantEntries[0].name, plans: TestData.plants[0].plans, errorPopupsState: ErrorPopupsState()))
	}
}
