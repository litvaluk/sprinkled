import Foundation
import SwiftUI
import JWTDecode

final class TeamViewModel: ObservableObject {
	@Inject private var api: APIProtocol

	@AppStorage("accessToken") var accessToken = ""
	
	let teamId: Int
	@Published var teamName: String
	@Published var teamMembers: [TeamMember] = []
	@Published var showDeleteTeamModal = false
	@Published var showRenameTeamModal = false
	@Published var showRemoveTeamMemberModal = false
	@Published var teamMemberToBeRemoved: TeamMember?
	@Published var renameTeamModalValue = ""
	@Published var loading = false
	
	private let errorPopupsState: ErrorPopupsState
	
	init(teamId: Int, teamName: String, errorPopupsState: ErrorPopupsState) {
		self.teamId = teamId
		self.teamName = teamName
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func fetchTeamMembers() async {
		loading = true
		defer { loading = false }
		do {
			teamMembers = try await api.fetchTeamMembers(teamId: teamId)
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	func removeTeamMember(memberId: Int) async -> Bool {
		do {
			try await api.removeTeamMember(teamId: teamId, memberId: memberId)
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
	
	@MainActor
	func deleteTeam() async -> Bool {
		do {
			try await api.deleteTeam(teamId: teamId)
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
	
	@MainActor
	func renameTeam() async -> Bool {
		do {
			try await api.renameTeam(teamId: teamId, newName: renameTeamModalValue)
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
	
	@MainActor
	func giveAdminRights(userId: Int) async {
		do {
			try await api.giveAdminRights(teamId: teamId, userId: userId)
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	@MainActor
	func removeAdminRights(userId: Int) async {
		do {
			try await api.removeAdminRights(teamId: teamId, userId: userId)
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	func getAuthenticatedUserId() -> Int? {
		return try? decode(jwt: self.accessToken).userId
	}
	 
}
