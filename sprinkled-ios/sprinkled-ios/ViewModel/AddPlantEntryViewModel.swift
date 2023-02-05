import SwiftUI

final class AddPlantEntryViewModel: ObservableObject {
	@Inject var api: APIProtocol
	@Inject var storageManager: StorageManagerProtocol
	
	@Published var name = ""
	@Published var teamSummaries: [TeamSummary] = []
	@Published var loading = false
	@Published var teamSelection: String? = nil
	@Published var placeSelection: String? = nil
	@Published var image = UIImage(named: "PlaceholderImage")!
	@Published var showImagePickerChoiceSheet = false
	@Published var showPhotoLibraryImagePicker = false
	@Published var showCameraImagePicker = false
	@Published var imagePicked = false
	@Published var isProcessing = false
	@Published var errorMessage = ""
	@Published var isKeyboardPresented = false
	
	let plant: Plant
	var setupPlanPresented: Binding<Bool>
	var lastCreatedPlantEntry: Binding<CreatePlantEntryResponse?>
	private let errorPopupsState: ErrorPopupsState
	
	init(plant: Plant, errorPopupsState: ErrorPopupsState, setupPlanPresented: Binding<Bool>, lastCreatedPlantEntry: Binding<CreatePlantEntryResponse?>) {
		self.plant = plant
		self.errorPopupsState = errorPopupsState
		self.setupPlanPresented = setupPlanPresented
		self.lastCreatedPlantEntry = lastCreatedPlantEntry
	}
	
	@MainActor
	func fetchTeamSummaries() async {
		loading = true
		defer { loading = false }
		do {
			teamSummaries = try await api.fetchTeamSummaries()
			teamSelection = teamSummaries.first?.name
			updatePlaceSelection()
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	func updatePlaceSelection() {
		placeSelection = teamSummaries.first(where: {$0.name == teamSelection})?.places.first?.name
	}
	
	func getTeamOptions() -> [String] {
		return teamSummaries.map{$0.name}
	}
	
	func getPlaceOptions() -> [String] {
		return teamSummaries.first(where: {$0.name == teamSelection})?.places.map{$0.name} ?? []
	}
	
	@MainActor
	func createPlantEntry() async -> Bool {
		errorMessage = ""
		isProcessing = true
		defer { isProcessing = false }
		
		if (name.count < 3) {
			errorMessage = "Name must be at least 3 characters long."
			return false
		}
		
		do {
			let selectedTeam = teamSummaries.first(where: {$0.name == teamSelection})!
			guard let selectedPlace = selectedTeam.places.first(where: {$0.name == placeSelection}) else {
				errorMessage = "Invalid place (does at least one place exist in the selected team?)"
				return false
			}
			if (imagePicked) {
				let url = try await storageManager.uploadImage(image: image)
				lastCreatedPlantEntry.wrappedValue = try await api.addPlantEntry(name: name, headerPictureUrl: url, placeId: selectedPlace.id, plantId: plant.id)
			} else {
				lastCreatedPlantEntry.wrappedValue = try await api.addPlantEntry(name: name, headerPictureUrl: nil, placeId: selectedPlace.id, plantId: plant.id)
			}
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
