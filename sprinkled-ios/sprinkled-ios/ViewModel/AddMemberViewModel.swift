import SwiftUI

final class AddMemberViewModel: ObservableObject {
	@Inject var api: APIProtocol
	
	@Published var users: [User] = []
	@Published var filteredUsers: [User] = []
	@Published var searchText = ""
	@Published var loading = false
	
	let teamId: Int
	let teamName: String
	var teamMemberIds: [Int]
	
	init(teamId: Int, teamName: String, teamMemberIds: [Int]) {
		self.teamId = teamId
		self.teamName = teamName
		self.teamMemberIds = teamMemberIds
	}
	
	@MainActor
	func updateFilteredUsers() {
		if (searchText.isEmpty) {
			filteredUsers = users
			return
		}
		filteredUsers = users.filter({$0.username.localizedCaseInsensitiveContains(searchText)})
			.sorted {$0.username < $1.username}
	}

	@MainActor
	func resetSearchText() {
		searchText = ""
	}
	
	@MainActor
	func fetchUsers() async {
		loading = true
		defer { loading = false }
		do {
			users = try await api.fetchUsers()
			users = users.filter({ user in
				!teamMemberIds.contains(user.id)
			})
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
			users = []
		}
		updateFilteredUsers()
	}
	
	@MainActor
	func addTeamMember(userId: Int) async {
		do {
			try await api.addTeamMember(teamId: teamId, userId: userId)
			teamMemberIds.append(userId)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
			users = []
		}
	}
}
