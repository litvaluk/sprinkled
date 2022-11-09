import SwiftUI
import Collections

final class TaskViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var uncompletedEventsMap: OrderedDictionary<String, [Event]>? = nil
	@Published var navigationPath = NavigationPath()
	
	@MainActor
	func fetchUncompletedEvents() async {
		var uncompletedEvents: [Event]
		do {
			uncompletedEvents = try await api.fetchUncompletedEvents()
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
			return
		} catch {
			print("❌ Error while fetching plants.")
			return
		}
		uncompletedEvents = uncompletedEvents.filter { $0.date > .now }
		uncompletedEventsMap = OrderedDictionary.init(grouping: uncompletedEvents) { event in
			event.date.toString(.MMMd)
		}
		
	}
}
