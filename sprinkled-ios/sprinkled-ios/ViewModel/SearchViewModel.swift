import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var plants: [Plant] = []
	@Published var filteredPlants: [Plant] = []
	@Published var searchText = ""
	@Published var loading = false
	@Published var path: [Plant] = []
	
	private let errorPopupsState: ErrorPopupsState
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
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
		defer { loading = false }
		do {
			plants = try await api.fetchPlants()
			updateFilteredPlants()
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
}
