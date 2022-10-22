import Foundation
import SwiftUI

final class CreateTeamViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var teamName = ""
	@Published var isProcessing = false
	@Published var errorMessage = ""
	
	@MainActor
	func createNewTeam() async -> Bool {
		isProcessing = true
		defer { isProcessing = false }
		
		do {
			_ = try await api.createNewTeam(name: teamName)
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
