import SwiftUI
import Kingfisher

enum PlaceAction: Hashable, Equatable {
	case addPlantEntry
}

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
					if let place = viewModel.place {
						ForEach(place.plantEntries) { plantEntry in
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
										.overlay {
											LinearGradient(gradient: Gradient(colors: [.clear, .clear, Color.primary]), startPoint: .top, endPoint: .bottom)
										}
									VStack {
										Spacer()
										HStack(alignment: .bottom) {
											Text(plantEntry.name)
												.font(.callout)
												.foregroundColor(Color.init(uiColor: UIColor.systemBackground))
											Spacer()
										}
									}
									.padding(6)
								}
								.cornerRadius(10)
							}
						}
						NavigationLink(value: PlaceAction.addPlantEntry) {
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
					} else {
						ForEach(0..<5) { _ in
							ZStack {
								Color.sprinkledDarkerGray
									.aspectRatio(1, contentMode: .fill)
									.clipped()
							}
							.cornerRadius(10)
							.redactedShimmering()
						}
					}
				}
			}
		}
		.padding(.horizontal)
		.padding(.bottom)
		.navigationTitle(viewModel.placeName)
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
							viewModel.placeName = viewModel.renamePlaceModalValue
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
		.onChange(of: viewModel.navigationPathBinding.wrappedValue) { newNavigationPath in
			if (newNavigationPath.isEmpty) {
				Task {
					await viewModel.fetchPlace()
				}
			}
		}
		.navigationDestination(for: TeamSummaryPlantEntry.self) { plantEntry in
			PlantEntryView(vm: PlantEntryViewModel(plantEntryId: plantEntry.id, errorPopupsState: errorPopupsState))
		}
		.navigationDestination(for: PlaceAction.self) { action in
			switch(action) {
			case .addPlantEntry:
				SearchView(viewModel: SearchViewModel(errorPopupsState: errorPopupsState, navigationPathBinding: viewModel.navigationPathBinding))
			}
		}
		.task {
			await viewModel.fetchPlace()
		}
	}
}

struct PlaceView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			PlaceView(viewModel: PlaceViewModel(placeId: 1, placeName: "Place 1", teamName: "Personal", navigationPathBinding: .constant(NavigationPath()), errorPopupsState: ErrorPopupsState()))
		}
	}
}
