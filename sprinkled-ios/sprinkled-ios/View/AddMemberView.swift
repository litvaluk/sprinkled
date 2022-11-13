import SwiftUI

struct AddMemberView: View {
	@StateObject var vm: AddMemberViewModel
	
    var body: some View {
		ScrollView {
			HStack {
				TextField("Search users", text: $vm.searchText)
					.autocorrectionDisabled(true)
					.textInputAutocapitalization(.none)
					.padding([.leading, .trailing])
					.onChange(of: vm.searchText) { _ in
						vm.updateFilteredUsers()
					}
				Button {
					vm.resetSearchText()
				} label: {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.secondary)
						.padding([.trailing])
				}
			}
			.frame(height: 40)
			.background(Color.sprinkledGray)
			.cornerRadius(15)
			.padding([.bottom], 20)
			VStack {
				if (vm.loading && vm.users.isEmpty) {
					ForEach(0..<5) { _ in
						SprinkledListItem(title: .placeholder(8)) {
							AddButton() {}
						}
						.redactedShimmering()
					}
				} else {
					ForEach(vm.filteredUsers) { user in
						SprinkledListItem(title: user.username) {
							AddButton() {
								await vm.addTeamMember(userId: user.id)
							}
						}
					}
				}
			}
		}
		.onAppear {
			Task {
				await vm.fetchUsers()
			}
		}
		.padding(.horizontal)
		.padding(.bottom)
		.navigationTitle("Add member")
    }
}

struct AddButton: View {
	let action: () async -> Void
	@State var adding = false
	@State var added = false
	
	var body: some View {
		if (added) {
			Text("Added")
				.font(.subheadline)
				.fontWeight(.medium)
				.foregroundColor(.secondary)
		} else if (adding) {
			ProgressView()
		} else {
			Button {
				adding = true
				Task {
					await action()
					added = true
				}
			} label: {
				Image(systemName: "plus.circle.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 20, height: 20)
					.fontWeight(.semibold)
					.foregroundColor(.primary)
					.padding(.trailing)
			}
		}
	}
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
		AddMemberView(vm: AddMemberViewModel(teamId: 1, teamName: "Team 1", teamMemberIds: TestData.teamMembers.map{$0.id}))
    }
}