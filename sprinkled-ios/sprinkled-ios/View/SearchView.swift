import SwiftUI
import Kingfisher

struct SearchView: View {
	@StateObject var viewModel: SearchViewModel
	
	var body: some View {
		NavigationStack {
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
					if (viewModel.plants.isEmpty && viewModel.loading) {
						ProgressView()
							.frame(width: gr.size.width, height: gr.size.height - 100)
					} else {
						ForEach(viewModel.filteredPlants) { plant in
							NavigationLink {} label: {
								HStack {
									KFImage(URL(string: plant.pictureUrl)!)
										.resizable()
										.frame(width: 60, height: 60)
										.scaledToFill()
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
					}
				}
				.navigationTitle("Search plants")
				.onAppear {
					Task {
						await viewModel.fetchPlants()
					}
				}
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(viewModel: SearchViewModel(dependencies: dependencies))
	}
}
