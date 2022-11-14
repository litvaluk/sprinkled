import SwiftUI
import Collections

final class TaskViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var uncompletedEventsMap: OrderedDictionary<String, [Event]>? = nil
	@Published var navigationPath = NavigationPath()
	
	private let errorPopupsState: ErrorPopupsState
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func fetchUncompletedEvents() async {
		var uncompletedEvents: [Event]
		do {
			uncompletedEvents = try await api.fetchUncompletedEvents()
		} catch APIError.expiredRefreshToken {
			return
		} catch APIError.notConnectedToInternet {
			errorPopupsState.showConnectionError = true
			return
		} catch {
			errorPopupsState.showGenericError = true
			return
		}
		uncompletedEvents = uncompletedEvents.filter { $0.date > .now }
		uncompletedEventsMap = OrderedDictionary.init(grouping: uncompletedEvents) { event in
			event.date.toString(.MMMd)
		}
		
	}
}
