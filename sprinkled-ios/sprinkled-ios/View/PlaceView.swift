import SwiftUI
import Kingfisher

struct PlaceView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	@StateObject var viewModel: PlaceViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			ScrollView {
				HStack {
					Text(viewModel.teamName)
						.fontWeight(.medium)
						.font(.title2)
					Spacer()
				}
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
					ForEach(viewModel.place.plantEntries) { plantEntry in
						NavigationLink(value: plantEntry) {
							ZStack {
								Color.clear
									.aspectRatio(1, contentMode: .fill)
									.clipped()
									.overlay {
										if let unwrappedHeaderPictureUrl = plantEntry.headerPictureUrl {
											KFImage(URL(string: unwrappedHeaderPictureUrl)!)
												.resizable()
												.scaledToFill()
										} else {
											Image("GridPlaceholderImage")
												.resizable()
												.scaledToFill()
										}
									}
								VStack {
									Spacer()
									HStack(alignment: .bottom) {
										Text(plantEntry.name)
											.font(.callout)
											.foregroundColor(.black)
										Spacer()
									}
								}
								.padding(6)
							}
							.cornerRadius(10)
						}
					}
					Button {} label: {
						ZStack {
							RoundedRectangle(cornerRadius: 15)
								.aspectRatio(1, contentMode: .fill)
								.foregroundColor(.sprinkledGray)
							Image(systemName: "plus")
								.resizable()
								.frame(width: 50, height: 50)
								.scaledToFit()
								.foregroundColor(.gray)
							
						}
						.cornerRadius(10)
					}
				}
			}
		}
		.padding(.horizontal)
		.padding(.bottom)
		.navigationTitle(viewModel.place.name)
		.toolbar {
			ToolbarItem {
				Menu {
					Button {
						withAnimation(.easeIn(duration: 0.07)) {
							viewModel.showRenamePlaceModal = true
						}
					} label: {
						Text("Rename place")
					}
					Button {
						withAnimation(.easeIn(duration: 0.07)) {
							viewModel.showDeletePlaceModal = true
						}
					} label: {
						Text("Delete place")
					}
				} label: {
					Image(systemName: "ellipsis.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 25, height: 25)
						.foregroundColor(.sprinkledGreen)
				}
			}
		}
		.modal(title: "Are you sure?", showModal: $viewModel.showDeletePlaceModal) {
			Text("This action will delete all plants associated with this place.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await viewModel.deletePlace()) {
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
					viewModel.showDeletePlaceModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.modal(title: "Choose a new name", showModal: $viewModel.showRenamePlaceModal) {
			TextField("Name", text: $viewModel.renamePlaceModalValue)
				.textFieldStyle(SprinkledTextFieldStyle())
				.autocorrectionDisabled()
				.textInputAutocapitalization(.never)
		} buttons: {
			Button {
				Task {
					if (await viewModel.renamePlace()) {
						withAnimation(.easeOut(duration: 0.07)) {
							viewModel.showRenamePlaceModal = false
							viewModel.place = TeamSummaryPlace(id: viewModel.place.id, name: viewModel.renamePlaceModalValue, plantEntries: viewModel.place.plantEntries)
							viewModel.renamePlaceModalValue = ""
							
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
					viewModel.showRenamePlaceModal = false
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.navigationDestination(for: TeamSummaryPlantEntry.self) { plantEntry in
			PlantEntryView(vm: PlantEntryViewModel(plantEntryId: plantEntry.id, errorPopupsState: errorPopupsState))
		}
	}
}

struct PlaceView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			PlaceView(viewModel: PlaceViewModel(place: TestData.teamSummaries[0].places[0], teamName: "Personal", errorPopupsState: ErrorPopupsState()))
		}
	}
}
