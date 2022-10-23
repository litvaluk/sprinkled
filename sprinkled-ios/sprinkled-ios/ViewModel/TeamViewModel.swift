import Foundation
import SwiftUI

final class TeamViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	let teamId: Int
	@Published var teamName: String
	@Published var teamMembers: [TeamMember] = []
	@Published var showDeleteTeamModal = false
	@Published var showRenameTeamModal = false
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
			print("❌ Error while fetching plants.")
		}
	}
	
	@MainActor
	func deleteTeam() async -> Bool {
		do {
			try await api.deleteTeam(teamId: teamId)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
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
			print("❌ Error while fetching plants.")
		}
		return false
	}
	
}
