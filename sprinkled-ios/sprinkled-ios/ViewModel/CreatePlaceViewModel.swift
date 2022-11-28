import Foundation
import SwiftUI

final class CreatePlaceViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var placeName = ""
	@Published var teamSelection: Int
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	let teamSummaries: [TeamSummary]
	
	private let errorPopupsState: ErrorPopupsState
	
	init(teamSummaries: [TeamSummary], teamSelection: Int, errorPopupsState: ErrorPopupsState) {
		self.teamSummaries = teamSummaries
		self.teamSelection = teamSelection
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func createNewPlace() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		if (placeName.count < 3) {
			errorMessage = "Name must be at least 3 characters long."
			return false
		}
		
		do {
			if (teamSelection == 0) {
				_ = try await api.createNewPlace(name: placeName)
			} else {
				_ = try await api.createNewTeamPlace(name: placeName, teamId: teamSelection)
			}
			errorPopupsState.presentSuccessPopup(text: "Place created")
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
