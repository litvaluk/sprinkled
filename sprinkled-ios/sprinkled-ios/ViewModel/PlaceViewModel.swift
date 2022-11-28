import Foundation
import SwiftUI

final class PlaceViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	let teamName: String
	@Published var place: TeamSummaryPlace?
	@Published var showDeletePlaceModal = false
	@Published var showRenamePlaceModal = false
	@Published var renamePlaceModalValue = ""
	@Published var loading = false
	
	var navigationPathBinding: Binding<NavigationPath>
	var placeId: Int
	var placeName: String
	private let errorPopupsState: ErrorPopupsState
	
	init(placeId: Int, placeName: String, teamName: String, navigationPathBinding: Binding<NavigationPath>, errorPopupsState: ErrorPopupsState) {
		self.placeId = placeId
		self.placeName = placeName
		self.teamName = teamName
		self.navigationPathBinding = navigationPathBinding
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func fetchPlace() async {
		loading = true
		defer { loading = false }
		do {
			place = try await api.fetchPlace(placeId: placeId)
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	@MainActor
	func deletePlace() async -> Bool {
		do {
			try await api.deletePlace(placeId: placeId)
			errorPopupsState.presentSuccessPopup(text: "Place deleted")
			return true
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
		return false
	}
	
	@MainActor
	func renamePlace() async -> Bool {
		do {
			try await api.renamePlace(placeId: placeId, newName: renamePlaceModalValue)
			errorPopupsState.presentSuccessPopup(text: "Place renamed")
			return true
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
		return false
	}
}
