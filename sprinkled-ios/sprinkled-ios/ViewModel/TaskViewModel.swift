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
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
			return
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
			return
		} catch {
			errorPopupsState.showGenericError = true
			return
		}
		uncompletedEventsMap = OrderedDictionary.init(grouping: uncompletedEvents.sorted()) { event in
			event.date.toString(.MMMd)
		}
	}
	
	@MainActor
	func completeEvent(eventId: Int) async -> Bool {
		do {
			try await api.completeEvent(eventId: eventId)
			return true
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
		return false
	}
}
