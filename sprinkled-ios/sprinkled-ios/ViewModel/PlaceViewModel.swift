import Foundation
import SwiftUI

final class PlaceViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	let teamName: String
	@Published var place: TeamSummaryPlace
	@Published var showDeletePlaceModal = false
	@Published var showRenamePlaceModal = false
	@Published var renamePlaceModalValue = ""
	
	init(place: TeamSummaryPlace, teamName: String) {
		self.place = place
		self.teamName = teamName
	}
	
	@MainActor
	func deletePlace() async -> Bool {
		do {
			try await api.deletePlace(placeId: place.id)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
		}
		return false
	}
	
	@MainActor
	func renamePlace() async -> Bool {
		do {
			try await api.renamePlace(placeId: place.id, newName: renamePlaceModalValue)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
		}
		return false
	}
}
