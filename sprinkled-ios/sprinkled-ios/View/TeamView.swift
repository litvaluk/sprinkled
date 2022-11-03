import SwiftUI

struct TeamView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: TeamViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack{
				Text("Members")
					.font(.title2)
					.fontWeight(.medium)
				Spacer()
			}
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
						if (vm.teamMembers.contains(where: {$0.id == vm.getAuthenticatedUserId() && $0.isAdmin})) {
							Menu {
								Button {} label: {
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
								Image(systemName: "ellipsis")
									.resizable()
									.scaledToFit()
									.frame(width: 20)
									.foregroundColor(.primary)
							}
						}
					}
					.padding(.horizontal)
				}
				.frame(height: 45)
			}
			Spacer()
		}
		.padding()
		.navigationTitle(vm.teamName)
		.toolbar {
			if (vm.teamMembers.contains(where: {$0.id == vm.getAuthenticatedUserId() && $0.isAdmin})) {
				ToolbarItem {
					Menu {
						Button {} label: {
							Text("Add member")
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
					} label: {
						Image(systemName: "ellipsis")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25)
							.foregroundColor(.primary)
					}
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
						self.presentationMode.wrappedValue.dismiss()
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
		.task {
			await vm.fetchTeamMembers()
		}
	}
}

struct TeamView_Previews: PreviewProvider {
	static var previews: some View {
		TeamView(vm: TeamViewModel(teamId: 1, teamName: "Team 1"))
	}
}
