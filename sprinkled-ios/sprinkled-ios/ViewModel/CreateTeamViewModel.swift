import Foundation
import SwiftUI

final class CreateTeamViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var teamName = ""
	@Published var isProcessing = false
	
	private let errorPopupsState: ErrorPopupsState
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func createNewTeam() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		do {
			_ = try await api.createNewTeam(name: teamName)
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
