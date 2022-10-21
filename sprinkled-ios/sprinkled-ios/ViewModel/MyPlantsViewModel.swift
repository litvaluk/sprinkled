import Foundation
import SwiftUI

final class MyPlantsViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var teamSummaries: [TeamSummary] = []
	@Published var loading = false
	@Published var navigationPath = NavigationPath()
	
	@MainActor
	func fetchTeamSummaries() async {
		loading = true
		do {
			teamSummaries = try await api.fetchTeamSummaries()
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching team summaries.")
			teamSummaries = []
		}
		loading = false
	}
}
