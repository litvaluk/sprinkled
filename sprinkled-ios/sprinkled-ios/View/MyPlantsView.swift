import SwiftUI
import Kingfisher

enum MyPlantsMenuAction: Hashable, Equatable {
	case createNewTeam
	case createNewPlace(Int)
	case addPlantEntry
}

struct MyPlantsView: View {
	@StateObject var viewModel: MyPlantsViewModel
	@EnvironmentObject var tabBarState: TabBarState
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	
	var body: some View {
		NavigationStack(path: $viewModel.navigationPath) {
			ScrollView {
				if (viewModel.loading && viewModel.teamSummaries.isEmpty) {
					ForEach(0..<2) { i in
						TeamCardsView(teamSummary: nil)
							.redactedShimmering()
					}
				} else {
					VStack(alignment: .leading, spacing: 35) {
						ForEach(viewModel.teamSummaries) { teamSummary in
							TeamCardsView(teamSummary: teamSummary)
						}
					}
					.padding(.top, 15)
				}
			}
			.navigationTitle("My plants")
			.toolbar {
				ToolbarItem {
					Menu {
						NavigationLink(value: MyPlantsMenuAction.createNewTeam) {
							Text("Create new team")
						}
						NavigationLink(value: MyPlantsMenuAction.createNewPlace(0)) {
							Text("Create new place")
						}
						NavigationLink(value: MyPlantsMenuAction.addPlantEntry) {
							Text("Add plant entry")
						}
					} label: {
						Image(systemName: "plus.app.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25)
							.foregroundColor(.sprinkledGreen)
					}
				}
			}
			.navigationDestination(for: TeamSummaryPlace.self) { place in
				PlaceView(viewModel: PlaceViewModel(place: place, teamName: viewModel.teamSummaries.first(where: {$0.places.contains(place)})?.name ?? "Personal", errorPopupsState: errorPopupsState))
			}
			.navigationDestination(for: TeamSummary.self) { team in
				TeamView(vm: TeamViewModel(teamId: team.id, teamName: team.name, errorPopupsState: errorPopupsState))
			}
			.navigationDestination(for: MyPlantsMenuAction.self) { action in
				switch (action) {
				case .createNewTeam:
					CreateTeamView(viewModel: CreateTeamViewModel(errorPopupsState: errorPopupsState))
				case .createNewPlace(let teamId):
					CreatePlaceView(viewModel: CreatePlaceViewModel(teamSummaries: viewModel.teamSummaries, teamSelection: teamId, errorPopupsState: errorPopupsState))
				case .addPlantEntry:
					SearchView(viewModel: SearchViewModel(errorPopupsState: errorPopupsState))
				}
			}
			.onChange(of: viewModel.navigationPath) { newNavigationPath in
				if (newNavigationPath.isEmpty) {
					Task {
						await viewModel.fetchTeamSummaries()
					}
				}
			}
			.onChange(of: tabBarState.tappedSameCount) { tappedSameCount in
				if (tappedSameCount > 0 && !viewModel.navigationPath.isEmpty) {
					viewModel.navigationPath = .init()
				}
			}
		}
		.task {
			await viewModel.fetchTeamSummaries()
		}
	}
}

struct TeamCardsView: View {
	let teamSummary: TeamSummary?
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack {
				if let teamSummary {
					if (teamSummary.id != 0) {
						NavigationLink(value: teamSummary) {
							Text(teamSummary.name)
								.font(.title2)
								.foregroundColor(.primary)
								.fontWeight(.medium)
							Image(systemName: "chevron.right")
								.resizable()
								.scaledToFit()
								.fontWeight(.semibold)
								.frame(width: 14, height: 14)
								.foregroundColor(.sprinkledGreen)
						}
					} else {
						Text(teamSummary.name)
							.font(.title2)
							.foregroundColor(.primary)
							.fontWeight(.medium)
					}
				} else {
					Text(String.placeholder(10))
						.font(.title2)
						.foregroundColor(.primary)
						.fontWeight(.medium)
				}
				Spacer()
			}
			ScrollView(.horizontal, showsIndicators: false) {
				if let teamSummary {
					HStack {
						ForEach(teamSummary.places) { place in
							SingleCardView(teamSummaryPlace: place)
						}
						AddCardView(teamId: teamSummary.id)
					}
					.frame(maxWidth: .infinity)
				} else {
					HStack {
						ForEach(0..<3) { _ in
							SingleCardView(teamSummaryPlace: nil)
						}
					}
					.frame(maxWidth: .infinity)
				}
			}
		}
		.padding([.horizontal])
	}
}

struct SingleCardView: View {
	let teamSummaryPlace: TeamSummaryPlace?
	
	var body: some View {
		VStack(spacing: 5) {
			NavigationLink(value: teamSummaryPlace) {
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.foregroundColor(.sprinkledGray)
						.frame(width: 120, height: 120)
					GridView(teamSummaryPlace: teamSummaryPlace)
						.padding(8)
				}
			}
			Text(teamSummaryPlace?.name ?? .placeholder(8))
		}
	}
}

struct AddCardView: View {
	let teamId: Int
	
	var body: some View {
		VStack {
			NavigationLink(value: MyPlantsMenuAction.createNewPlace(teamId)) {
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.foregroundColor(.sprinkledGray)
						.frame(width: 120, height: 120)
					Image(systemName: "plus")
						.resizable()
						.frame(width: 50, height: 50)
						.scaledToFit()
						.foregroundColor(.gray)
				}
			}
			Spacer()
		}
	}
}

struct GridView: View {
	let teamSummaryPlace: TeamSummaryPlace?
	
	var body: some View {
		Grid {
			if let teamSummaryPlace {
				GridRow {
					if (teamSummaryPlace.plantEntries.count > 0) {
						GridItemView(plantEntry: teamSummaryPlace.plantEntries[0])
					} else {
						Color.clear
					}
					if (teamSummaryPlace.plantEntries.count > 1) {
						GridItemView(plantEntry: teamSummaryPlace.plantEntries[1])
					} else {
						Color.clear
					}
				}
				GridRow {
					if (teamSummaryPlace.plantEntries.count > 2) {
						GridItemView(plantEntry: teamSummaryPlace.plantEntries[2])
					} else {
						Color.clear
					}
					if (teamSummaryPlace.plantEntries.count > 3) {
						GridItemView(plantEntry: teamSummaryPlace.plantEntries[3])
					} else {
						Color.clear
					}
				}
			} else {
				GridRow {
					GridItemView(plantEntry: nil)
					GridItemView(plantEntry: nil)
				}
				GridRow {
					GridItemView(plantEntry: nil)
				}
			}
		}
	}
}

struct GridItemView: View {
	let plantEntry: TeamSummaryPlantEntry?
	
	var body: some View {
		if let headerPictureUrl = plantEntry?.headerPictureUrl {
			Color.clear
				.aspectRatio(1, contentMode: .fill)
				.clipped()
				.overlay {
					KFImage(URL(string: headerPictureUrl)!)
						.resizable()
						.scaledToFill()
				}
				.cornerRadius(10)
		} else {
			Color.clear
				.aspectRatio(1, contentMode: .fill)
				.clipped()
				.overlay {
					Image("GridPlaceholderImage")
						.resizable()
						.scaledToFill()
				}
				.cornerRadius(10)
		}
	}
}

struct MyPlantsView_Previews: PreviewProvider {
	static var previews: some View {
		MyPlantsView(viewModel: MyPlantsViewModel(errorPopupsState: ErrorPopupsState()))
			.environmentObject(TabBarState())
	}
}
