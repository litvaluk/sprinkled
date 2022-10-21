import SwiftUI
import Kingfisher

struct MyPlantsView: View {
	@StateObject var viewModel: MyPlantsViewModel
	
	var body: some View {
		NavigationStack(path: $viewModel.navigationPath) {
			ScrollView {
				if (viewModel.loading) {
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
						NavigationLink(destination: CreateTeamView()) {
							Text("Create new team")
						}
						NavigationLink(destination: CreatePlaceView()) {
							Text("Create new place")
						}
						NavigationLink(destination: SearchView(viewModel: SearchViewModel())) {
							Text("Add plant entry")
						}
					} label: {
						Image(systemName: "ellipsis")
							.resizable()
							.scaledToFit()
							.frame(width: 25)
							.foregroundColor(.black)
					}
				}
			}
			.navigationDestination(for: TeamSummaryPlace.self) { place in
				PlaceView(place: place)
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
						.foregroundColor(.black)
				}
			}
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(teamSummary.places) { place in
						SingleCardView(teamSummaryPlace: place)
					}
					AddCardView()
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
	var body: some View {
		VStack {
			NavigationLink(destination: CreatePlaceView()) {
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
