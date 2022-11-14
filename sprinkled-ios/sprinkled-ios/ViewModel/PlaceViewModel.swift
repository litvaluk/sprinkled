import Foundation
import SwiftUI

final class PlaceViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	let teamName: String
	@Published var place: TeamSummaryPlace
	@Published var showDeletePlaceModal = false
	@Published var showRenamePlaceModal = false
	@Published var renamePlaceModalValue = ""
	
	private let errorPopupsState: ErrorPopupsState
	
	init(place: TeamSummaryPlace, teamName: String, errorPopupsState: ErrorPopupsState) {
		self.place = place
		self.teamName = teamName
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func deletePlace() async -> Bool {
		do {
			try await api.deletePlace(placeId: place.id)
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
			try await api.renamePlace(placeId: place.id, newName: renamePlaceModalValue)
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
