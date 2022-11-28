import Foundation
import SwiftUI

final class CreateTeamViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var teamName = ""
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	private let errorPopupsState: ErrorPopupsState
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func createNewTeam() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		if (teamName.count < 3) {
			errorMessage = "Name must be at least 3 characters long."
			return false
		}
		
		do {
			_ = try await api.createNewTeam(name: teamName)
			errorPopupsState.presentSuccessPopup(text: "Team created")
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
