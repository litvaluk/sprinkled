import SwiftUI

struct TaskView: View {
	@StateObject var vm: TaskViewModel
	
	var body: some View {
		NavigationStack(path: $vm.navigationPath) {
			ScrollView {
				if let reminderMap = vm.reminderMap {
					if (reminderMap.isEmpty) {
						Text("No upcoming tasks")
							.foregroundColor(.secondary)
							.padding(100)
							
					} else {
						LazyVStack(spacing: 7) {
							ForEach(Array(reminderMap), id: \.key) { dayAndMonths, reminders in
								Section {
									VStack(spacing: 7) {
										ForEach(reminders, id: \.id) { reminder in
											NavigationLink(value: reminder.plantEntry) {
												TaskListItem(title: reminder.action.type.capitalizedFirstLetter(), subtitle: "\(reminder.plantEntry.name)", date: reminder.date)
											}
										}
									}
									.padding(.bottom)
								} header: {
									HStack {
										Text(dayAndMonths)
											.font(.subheadline)
											.foregroundColor(.secondary)
											.fontWeight(.semibold)
										Spacer()
									}
								}
							}
						}
						.padding()
					}
				} else {
					VStack {
						ForEach(0..<2) { _ in
							Section {
								VStack(spacing: 7) {
									ForEach(0..<2) { _ in
										TaskListItem(title: .placeholder(8), subtitle: .placeholder(8), date: .placeholder)
											.redactedShimmering()
									}
								}
								.padding(.bottom)
							} header: {
								HStack {
									Text(String.placeholder(5))
										.font(.subheadline)
										.foregroundColor(.secondary)
										.fontWeight(.semibold)
									Spacer()
								}
								.redactedShimmering()
							}
						}
					}
					.padding()
				}
			}
			.navigationDestination(for: ReminderForTaskView.PlantEntryIdAndName.self) { plantEntryIdAndName in
				AddEventView(vm: AddEventViewModel(plantEntryId: plantEntryIdAndName.id, plantEntryName: plantEntryIdAndName.name))
			}
			.navigationTitle("Tasks")
			.navigationBarTitleDisplayMode(.large)
			.task {
				await vm.fetchReminders()
			}
		}
	}
}

struct TaskListItem: View {
	let title: String
	let subtitle: String
	let date: Date
	
	var body: some View {
		ZStack {
			Color.sprinkledGray
			HStack {
				RoundedRectangle(cornerRadius: 7)
					.foregroundColor(.gray)
					.frame(width: 50, height: 50)
					.padding(5)
				VStack(alignment: .leading) {
					Text(title)
						.foregroundColor(.primary)
						.fontWeight(.medium)
					Text(subtitle)
						.foregroundColor(.primary)
				}
				Spacer()
				Text(date.toString(.HHmm))
					.foregroundColor(.primary)
					.font(.subheadline)
					.padding(5)
				Image(systemName: "chevron.right")
					.resizable()
					.scaledToFit()
					.foregroundColor(.primary)
					.frame(width: 10, height: 10)
					.padding(.trailing, 10)
			}
		}
		.cornerRadius(10)
	}
}

struct TaskView_Previews: PreviewProvider {
	static var previews: some View {
		TaskView(vm: TaskViewModel())
	}
}
