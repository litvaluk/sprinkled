import SwiftUI

final class PlantEntryViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	@Inject private var storageManager: StorageManagerProtocol
	
	@Published var plantEntry: PlantEntry?
	@Published var selectedSection: PlantEntrySection = .history
	@Published var loading = false
	@Published var reminderToDelete: Int? = nil
	@Published var eventToDelete: Int? = nil
	@Published var image = UIImage()
	@Published var showImagePickerChoiceSheet = false
	@Published var showPhotoLibraryImagePicker = false
	@Published var showCameraImagePicker = false
	
	let plantEntryId: Int
	
	private let errorPopupsState: ErrorPopupsState

	init(plantEntryId: Int, errorPopupsState: ErrorPopupsState) {
		self.plantEntryId = plantEntryId
		self.errorPopupsState = errorPopupsState
	}
	
	@MainActor
	func fetchPlantEntry() async {
		loading = true
		defer { loading = false }
		do {
			plantEntry = try await api.fetchPlantEntry(plantEntryId: plantEntryId)
		} catch APIError.expiredRefreshToken, APIError.cancelled {
			// nothing
		} catch APIError.connectionFailed {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
	
	func deleteReminder() async -> Bool {
		guard let reminderToDelete else {
			print("reminderToDelete is nil")
			return false
		}
		do {
			try await api.deleteReminder(reminderId: reminderToDelete)
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
	
	func deleteEvent() async -> Bool {
		guard let eventToDelete else {
			print("eventToDelete is nil")
			return false
		}
		do {
			try await api.deleteEvent(eventId: eventToDelete)
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
	
	func savePhoto() async {
		do {
			let url = try await storageManager.uploadImage(image: image)
			print("Uploaded to Firebase Storage. Available at:", url.absoluteString)
			_ = try await api.createPicture(plantEntryId: plantEntryId, pictureUrl: url)
		} catch {
			print("❌ Error while uploading image to Firebase Storage.")
			errorPopupsState.showGenericError = true
		}
	}
}

enum PlantEntrySection : String, CaseIterable {
	case history = "History"
	case reminders = "Reminders"
	case gallery = "Gallery"
}
