import Foundation
import SwiftUI

final class CreatePlaceViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	let teamSummaries: [TeamSummary]
	
	init(teamSummaries: [TeamSummary], teamSelection: Int) {
		self.teamSummaries = teamSummaries
		self.teamSelection = teamSelection
	}
	
	@Published var placeName = ""
	@Published var teamSelection: Int
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	@MainActor
	func createNewPlace() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		do {
			if (teamSelection == 0) {
				_ = try await api.createNewPlace(name: placeName)
			} else {
				_ = try await api.createNewTeamPlace(name: placeName, teamId: teamSelection)
			}
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
			return false
		} catch {
			errorMessage = "Something went wrong."
			return false
		}
		
		return true
	}
	
}
