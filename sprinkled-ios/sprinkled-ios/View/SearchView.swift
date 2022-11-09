import SwiftUI
import Kingfisher

struct SearchView: View {
	@StateObject var viewModel: SearchViewModel
	@EnvironmentObject var tabBarState: TabBarState
	
	var body: some View {
		NavigationStack(path: $viewModel.path) {
			ScrollViewReader { proxy in
				GeometryReader { gr in
					ScrollView {
						HStack {
							TextField("Search", text: $viewModel.searchText)
								.autocorrectionDisabled(true)
								.textInputAutocapitalization(.none)
								.padding([.leading, .trailing])
								.onChange(of: viewModel.searchText) { _ in
									viewModel.updateFilteredPlants()
								}
							Button {
								viewModel.resetSearchText()
							} label: {
								Image(systemName: "xmark.circle.fill")
									.foregroundColor(.secondary)
									.padding([.trailing])
							}
						}
						.frame(height: 40)
						.background(Color("SprinkledGray"))
						.cornerRadius(15)
						.padding([.leading, .trailing], 16)
						.padding([.bottom], 8)
						.id("top")
						if (viewModel.plants.isEmpty && viewModel.loading) {
							ForEach(0..<5) { i in
								HStack {
									RoundedRectangle(cornerRadius: 10)
										.frame(width: 60, height: 60)
										.foregroundColor(.gray)
										.padding([.leading, .trailing], 12)
									VStack(alignment: .leading) {
										Text(String.placeholder(18))
											.foregroundColor(.primary)
										Text(String.placeholder(18))
											.font(.subheadline)
											.foregroundColor(.secondary)
									}
									.padding([.top, .bottom])
									Spacer()
								}
								.background(Color("SprinkledGray"))
								.cornerRadius(15)
								.padding([.leading, .trailing], 16)
								.redactedShimmering()
							}
						} else if (viewModel.filteredPlants.isEmpty) {
							Text("No plants found")
								.foregroundColor(.secondary)
								.padding(.top, 20)
						} else {
							ForEach(viewModel.filteredPlants) { plant in
								NavigationLink(value: plant) {
									HStack {
										KFImage(URL(string: plant.pictureUrl)!)
											.resizable()
											.scaledToFill()
											.frame(width: 60, height: 60)
											.cornerRadius(10)
											.padding([.leading, .trailing], 12)
										VStack(alignment: .leading) {
											Text(plant.commonName)
												.foregroundColor(.primary)
											Text(plant.latinName)
												.font(.subheadline)
												.foregroundColor(.secondary)
										}
										.padding([.top, .bottom])
										Spacer()
										Image(systemName: "chevron.right")
											.padding(12)
									}
								}
								.frame(height: 80)
								.background(Color("SprinkledGray"))
								.cornerRadius(15)
								.padding([.leading, .trailing], 16)
							}
							.navigationDestination(for: Plant.self) { plant in
								PlantDetailView(viewModel: PlantDetailViewModel(plant: plant))
									.onChange(of: tabBarState.tappedSameCount) { tappedSameCount in
										if (tappedSameCount > 0 && !viewModel.path.isEmpty) {
											viewModel.path = []
										}
									}
							}
						}
					}
					.onChange(of: tabBarState.tappedSameCount) { tappedSameCount in
						if (tappedSameCount > 0 && viewModel.path.isEmpty) {
							withAnimation {
								proxy.scrollTo("top")
							}
						}
					}
					.frame(width: gr.size.width, height: gr.size.height)
					.navigationTitle("Search plants")
					.onAppear {
						Task {
							await viewModel.fetchPlants()
						}
					}
				}
				.ignoresSafeArea(.keyboard, edges: .bottom)
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(viewModel: SearchViewModel())
			.environmentObject(TabBarState())
	}
}
