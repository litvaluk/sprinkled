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
	
	private let errorPopupsState: ErrorPopupsState
	
	init(teamId: Int, teamName: String, teamMemberIds: [Int], errorPopupsState: ErrorPopupsState) {
		self.teamId = teamId
		self.teamName = teamName
		self.teamMemberIds = teamMemberIds
		self.errorPopupsState = errorPopupsState
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
			updateFilteredUsers()
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	@MainActor
	func addTeamMember(userId: Int) async {
		do {
			try await api.addTeamMember(teamId: teamId, userId: userId)
			teamMemberIds.append(userId)
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
}
