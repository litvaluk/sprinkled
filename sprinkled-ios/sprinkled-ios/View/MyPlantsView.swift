import SwiftUI
import Kingfisher

enum MyPlantsMenuAction: Hashable, Equatable {
	case CreatNewTeam
	case CreateNewPlace(Int)
	case AddPlantEntry
}

struct MyPlantsView: View {
	@StateObject var viewModel: MyPlantsViewModel
	@EnvironmentObject var tabBarState: TabBarState
	
	var body: some View {
		NavigationStack(path: $viewModel.navigationPath) {
			ScrollView {
				if (viewModel.loading && viewModel.teamSummaries.isEmpty) {
					ProgressView()
						.padding(.top, 250)
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
						NavigationLink(value: MyPlantsMenuAction.CreatNewTeam) {
							Text("Create new team")
						}
						NavigationLink(value: MyPlantsMenuAction.CreateNewPlace(0)) {
							Text("Create new place")
						}
						NavigationLink(value: MyPlantsMenuAction.AddPlantEntry) {
							Text("Add plant entry")
						}
					} label: {
						Image(systemName: "plus.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25)
							.foregroundColor(.primary)
					}
				}
			}
			.navigationDestination(for: TeamSummaryPlace.self) { place in
				PlaceView(place: place, teamName: viewModel.teamSummaries.first(where: {$0.places.contains(place)})?.name ?? "Personal")
			}
			.navigationDestination(for: MyPlantsMenuAction.self) { action in
				switch (action) {
				case MyPlantsMenuAction.CreatNewTeam:
					CreateTeamView(viewModel: CreateTeamViewModel())
				case MyPlantsMenuAction.CreateNewPlace(let teamId):
					CreatePlaceView(viewModel: CreatePlaceViewModel(teamSummaries: viewModel.teamSummaries, teamSelection: teamId))
				case MyPlantsMenuAction.AddPlantEntry:
					SearchView(viewModel: SearchViewModel())
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
	let teamSummary: TeamSummary
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack{
				Text(teamSummary.name)
					.font(.title2)
					.fontWeight(.medium)
				Spacer()
				Button {} label: {
					Image(systemName: "ellipsis")
						.resizable()
						.scaledToFit()
						.frame(width: 20)
						.foregroundColor(.primary)
				}
			}
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(teamSummary.places) { place in
						SingleCardView(teamSummaryPlace: place)
					}
					AddCardView(teamId: teamSummary.id)
				}
				.frame(maxWidth: .infinity)
			}
		}
		.padding([.horizontal])
	}
}

struct SingleCardView: View {
	let teamSummaryPlace: TeamSummaryPlace
	
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
			Text(teamSummaryPlace.name)
		}
	}
}

struct AddCardView: View {
	let teamId: Int
	
	var body: some View {
		VStack {
			NavigationLink(value: MyPlantsMenuAction.CreateNewPlace(teamId)) {
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
	let teamSummaryPlace: TeamSummaryPlace
	
	var body: some View {
		Grid {
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
		}
	}
}

struct GridItemView: View {
	let plantEntry: TeamSummaryPlantEntry
	
	var body: some View {
		if let headerPictureUrl = plantEntry.headerPictureUrl {
			Color.clear
				.aspectRatio(1, contentMode: .fit)
				.overlay(
					KFImage(URL(string: headerPictureUrl)!)
						.resizable()
						.scaledToFill()
				)
				.clipShape(RoundedRectangle(cornerRadius: 10))
		} else {
			Color.clear
				.aspectRatio(1, contentMode: .fit)
				.overlay(
					Image("GridPlaceholderImage")
						.resizable()
						.scaledToFill()
				)
				.clipShape(RoundedRectangle(cornerRadius: 10))
		}
	}
}

struct MyPlantsView_Previews: PreviewProvider {
	static var previews: some View {
		MyPlantsView(viewModel: MyPlantsViewModel())
	}
}
