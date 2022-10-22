import SwiftUI
import Kingfisher

struct PlaceView: View {
	let place: TeamSummaryPlace
	let teamName: String
	
    var body: some View {
		VStack(alignment: .leading) {
			ScrollView {
				HStack {
					Text(teamName)
						.fontWeight(.medium)
						.font(.title2)
					Spacer()
				}
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
					ForEach(place.plantEntries) { plantEntry in
						Button {} label: {
							ZStack {
								if let unwrappedHeaderPictureUrl = plantEntry.headerPictureUrl {
									KFImage(URL(string: unwrappedHeaderPictureUrl)!)
										.resizable()
										.aspectRatio(1, contentMode: .fill)
										.clipped()
								} else {
									Image("GridPlaceholderImage")
										.resizable()
										.aspectRatio(1, contentMode: .fill)
										.clipped()
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
		.navigationTitle(place.name)
		.toolbar {
			ToolbarItem {
				Menu {
					Button {} label: {
						Text("Rename place")
					}
					Button {} label: {
						Text("Delete place")
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
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
		PlaceView(place: TestData.teamSummaries[0].places[0], teamName: "Personal")
    }
}
