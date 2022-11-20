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
											TaskListItem(title: event.action.type.capitalizedFirstLetter(), subtitle: "\(event.plantEntry.name)", action: event.action.type, date: event.date, redacted: false, complete: {
												return await vm.completeEvent(eventId: event.id)
											})
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
										TaskListItem(title: .placeholder(8), subtitle: .placeholder(8), action: nil, date: .placeholder, redacted: true, complete: {true})
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
	let redacted: Bool
	let complete: () async -> Bool
	
	var body: some View {
		ZStack {
			Color.sprinkledGray
			HStack {
				Color.sprinkledDarkerGray
					.aspectRatio(1, contentMode: .fit)
					.frame(width: 54, height: 54)
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
						.font(.subheadline)
						.foregroundColor(.primary)
						.fontWeight(.medium)
					Text(subtitle)
						.font(.subheadline)
						.foregroundColor(.primary)
					Text(date.toString(.HHmm))
						.foregroundColor(.primary)
						.font(.subheadline)
				}
				Spacer()
				SprinkledListActionButton(title: "Complete", completedTitle: "Completed") {
					return await complete()
				}
				.overlay {
					if (redacted) {
						RoundedRectangle(cornerRadius: 5)
							.foregroundColor(.sprinkledDarkerGray)
							.padding(.trailing, 9)
					}
				}
				.disabled(redacted)
			}
		}
		.cornerRadius(10)
		.redactedShimmering(if: redacted)
	}
}

struct TaskView_Previews: PreviewProvider {
	static var previews: some View {
		TaskView(vm: TaskViewModel(errorPopupsState: ErrorPopupsState()))
	}
}
