import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var plants: [Plant] = []
	@Published var filteredPlants: [Plant] = []
	@Published var searchText = ""
	@Published var loading = false
	@Published var path: [Plant] = []
	
	@MainActor
	func updateFilteredPlants() {
		if (searchText.isEmpty) {
			filteredPlants = plants
			return
		}
		filteredPlants = plants.filter({$0.commonName.localizedCaseInsensitiveContains(searchText) || $0.latinName.localizedCaseInsensitiveContains(searchText)})
			.sorted {$0.commonName < $1.commonName}
	}
	
	@MainActor
	func resetSearchText() {
		searchText = ""
	}
	
	@MainActor
	func fetchPlants() async {
		loading = true
		do {
			plants = try await api.fetchPlants()
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
			plants = []
		}
		updateFilteredPlants()
		loading = false
	}
}
