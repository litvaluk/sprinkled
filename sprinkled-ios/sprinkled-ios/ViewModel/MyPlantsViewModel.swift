import Foundation
import SwiftUI

final class MyPlantsViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var teamSummaries: [TeamSummary] = []
	@Published var loading = false
	@Published var navigationPath = NavigationPath()
	
	private let errorPopupsState: ErrorPopupsState
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func fetchTeamSummaries() async {
		loading = true
		defer { loading = false }
		do {
			teamSummaries = try await api.fetchTeamSummaries()
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
}
