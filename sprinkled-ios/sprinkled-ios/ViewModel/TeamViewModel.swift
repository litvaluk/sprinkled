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
	
	init(teamId: Int, teamName: String) {
		self.teamId = teamId
		self.teamName = teamName
	}
	
	@MainActor
	func fetchTeamMembers() async {
		do {
			teamMembers = try await api.fetchTeamMembers(teamId: teamId)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching team members.")
		}
	}
	
	func removeTeamMember(memberId: Int) async -> Bool {
		do {
			try await api.removeTeamMember(teamId: teamId, memberId: memberId)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while deleting team.")
		}
		return false
	}
	
	@MainActor
	func deleteTeam() async -> Bool {
		do {
			try await api.deleteTeam(teamId: teamId)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while deleting team.")
		}
		return false
	}
	
	@MainActor
	func renameTeam() async -> Bool {
		do {
			try await api.renameTeam(teamId: teamId, newName: renameTeamModalValue)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while renaming team.")
		}
		return false
	}
	
	@MainActor
	func giveAdminRights(userId: Int) async {
		do {
			try await api.giveAdminRights(teamId: teamId, userId: userId)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while giving admin rights.")
		}
	}
	
	@MainActor
	func removeAdminRights(userId: Int) async {
		do {
			try await api.removeAdminRights(teamId: teamId, userId: userId)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while removing admin rights.")
		}
	}
	
	func getAuthenticatedUserId() -> Int? {
		return try? decode(jwt: self.accessToken).userId
	}
	 
}
