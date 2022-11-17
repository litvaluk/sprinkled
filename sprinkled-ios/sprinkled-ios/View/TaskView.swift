import SwiftUI

struct TaskView: View {
	@StateObject var vm: TaskViewModel
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	
	var body: some View {
		NavigationStack(path: $vm.navigationPath) {
			ScrollView {
				if let uncompletedEventsMap = vm.uncompletedEventsMap {
					if (uncompletedEventsMap.isEmpty) {
						Text("No upcoming tasks")
							.foregroundColor(.secondary)
							.padding(100)
							
					} else {
						LazyVStack(spacing: 7) {
							ForEach(Array(uncompletedEventsMap), id: \.key) { dayAndMonths, event in
								Section {
									VStack(spacing: 7) {
										ForEach(event, id: \.id) { event in
											NavigationLink(value: event.plantEntry) {
												TaskListItem(title: event.action.type.capitalizedFirstLetter(), subtitle: "\(event.plantEntry.name)", action: event.action.type, date: event.date)
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
										TaskListItem(title: .placeholder(8), subtitle: .placeholder(8), action: nil, date: .placeholder)
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
			.navigationDestination(for: Event.PlantEntryIdAndName.self) { plantEntryIdAndName in
				AddEventView(vm: AddEventViewModel(plantEntryId: plantEntryIdAndName.id, plantEntryName: plantEntryIdAndName.name, errorPopupsState: errorPopupsState))
			}
			.navigationTitle("Tasks")
			.navigationBarTitleDisplayMode(.large)
			.task {
				await vm.fetchUncompletedEvents()
			}
		}
	}
}

struct TaskListItem: View {
	let title: String
	let subtitle: String
	let action: String?
	let date: Date
	
	var body: some View {
		ZStack {
			Color.sprinkledGray
			HStack {
				Color.sprinkledDarkerGray
					.aspectRatio(1, contentMode: .fit)
					.frame(width: 50, height: 50)
					.cornerRadius(7)
					.overlay {
						if let action {
							Image("\(action)ActionIcon")
								.resizable()
								.scaledToFit()
								.foregroundColor(.primary)
								.padding(5)
						}
					}
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
		TaskView(vm: TaskViewModel(errorPopupsState: ErrorPopupsState()))
	}
}
