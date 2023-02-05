import SwiftUI

enum TeamMenuAction: Hashable, Equatable {
	case addMember
}

struct TeamView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	@StateObject var vm: TeamViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack{
				Text("Members")
					.font(.title2)
					.fontWeight(.medium)
				Spacer()
			}
			if (vm.loading && vm.teamMembers.isEmpty) {
				ForEach(0..<5) { _ in
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.foregroundColor(.sprinkledGray)
						HStack {
							Text(String.placeholder(10))
							Spacer()
						}
					}
					.frame(height: 45)
					.redactedShimmering()
				}
			} else {
				teamMemberList()
			}
			Spacer()
		}
		.padding()
		.navigationTitle(vm.teamName)
		.toolbar {
			ToolbarItem {
				Menu {
					if (vm.teamMembers.contains(where: {$0.id == vm.getAuthenticatedUserId() && $0.isAdmin})) {
						Button {
							vm.addMemberLinkActive = true
						} label: {
							Text("Add member")
						}
						.navigationDestination(isPresented: $vm.addMemberLinkActive) {
							AddMemberView(vm: AddMemberViewModel(teamId: vm.teamId, teamName: vm.teamName, teamMemberIds: vm.teamMembers.map{$0.id}, errorPopupsState: errorPopupsState))
						}
						Button {
							withAnimation(.easeIn(duration: 0.07)) {
								vm.showRenameTeamModal = true
							}
						} label: {
							Text("Rename team")
						}
						Button {
							withAnimation(.easeIn(duration: 0.07)) {
								vm.showDeleteTeamModal = true
							}
						} label: {
							Text("Delete team")
						}
					}
					Button {
						vm.showLeaveTeamModal = true
					} label: {
						Text("Leave team")
					}
					.disabled(leaveTeamDisabled())
				} label: {
					Image(systemName: "ellipsis.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
						.foregroundColor(.sprinkledGreen)
				}
			}
		}
		.modal(title: "Are you sure?", showModal: $vm.showDeleteTeamModal) {
			Text("This action will delete all places and plants associated with this team.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await vm.deleteTeam()) {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				}
			} label: {
				Text("Delete")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.tint(.sprinkledRed)
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.showDeleteTeamModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.modal(title: "Choose a new name", showModal: $vm.showRenameTeamModal) {
			TextField("Name", text: $vm.renameTeamModalValue)
				.textFieldStyle(SprinkledTextFieldStyle())
				.autocorrectionDisabled()
				.textInputAutocapitalization(.never)
		} buttons: {
			Button {
				Task {
					if (await vm.renameTeam()) {
						withAnimation(.easeOut(duration: 0.07)) {
							vm.showRenameTeamModal = false
							vm.teamName = vm.renameTeamModalValue
							vm.renameTeamModalValue = ""
							
						}
					}
				}
			} label: {
				Text("Rename")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.showRenameTeamModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.modal(title: "Are you sure?", showModal: $vm.showLeaveTeamModal) {
			Text("This action will remove you from this team.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await vm.removeTeamMember(memberId: vm.getAuthenticatedUserId()!)) {
						self.presentationMode.wrappedValue.dismiss()
					}
				}
			} label: {
				Text("Leave")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.tint(.sprinkledRed)
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.showLeaveTeamModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.modal(title: "Are you sure?", showModal: $vm.showRemoveTeamMemberModal) {
			Text(vm.teamMemberToBeRemoved != nil ? "This action will remove user \(vm.teamMemberToBeRemoved!.username) from the team." : "This action will remove the user from the team.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await vm.removeTeamMember(memberId: vm.teamMemberToBeRemoved!.id)) {
						withAnimation(.easeOut(duration: 0.07)) {
							vm.showRemoveTeamMemberModal = false
						}
						await vm.fetchTeamMembers()
					}
				}
			} label: {
				Text("Remove")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.tint(.sprinkledRed)
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.showRemoveTeamMemberModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.task {
			await vm.fetchTeamMembers()
		}
	}
	
	func teamMemberList() -> some View {
		ForEach(vm.teamMembers) { member in
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(.sprinkledGray)
				HStack {
					Text(member.username)
					if (member.isAdmin) {
						Image(systemName: "gearshape.2.fill")
					}
					Spacer()
					if (shouldDisplayMemberMenu(memberId: member.id)) {
						Menu {
							Button {
								vm.teamMemberToBeRemoved = member
								vm.showRemoveTeamMemberModal = true
							} label: {
								Text("Remove member")
							}
							if (!member.isAdmin) {
								Button {
									Task {
										await vm.giveAdminRights(userId: member.id)
										await vm.fetchTeamMembers()
									}
								} label: {
									Text("Give admin rights")
								}
							} else if (vm.teamMembers.filter({$0.isAdmin}).count > 1) {
								Button {
									Task {
										await vm.removeAdminRights(userId: member.id)
										await vm.fetchTeamMembers()
									}
								} label: {
									Text("Remove admin rights")
								}
							}
						} label: {
							Image(systemName: "ellipsis.circle")
								.resizable()
								.scaledToFit()
								.frame(width: 20)
								.foregroundColor(.sprinkledGreen)
						}
					}
				}
				.padding(.horizontal)
			}
			.frame(height: 45)
		}
	}
	
	func shouldDisplayMemberMenu(memberId: Int) -> Bool {
		return memberId != vm.getAuthenticatedUserId() && vm.teamMembers.contains(where: {$0.id == vm.getAuthenticatedUserId() && $0.isAdmin})
	}
	
	func leaveTeamDisabled() -> Bool {
		let admins = vm.teamMembers.filter({ $0.isAdmin })
		return admins.count == 1 && admins[0].id == vm.getAuthenticatedUserId()
	}
}

struct TeamView_Previews: PreviewProvider {
	static var previews: some View {
		TeamView(vm: TeamViewModel(teamId: 1, teamName: "Team 1", errorPopupsState: ErrorPopupsState()))
	}
}
