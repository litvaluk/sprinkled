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
	@Published var showDeletePlantEntryModal = false
	@Published var showRenamePlantEntryModal = false
	@Published var renamePlantEntryModalValue = ""
	@Published var yOffset: CGFloat = 0
	@Published var addEventLinkActive = false
	@Published var addReminderLinkActive = false
	
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
	
	@MainActor
	func deletePlantEntry() async -> Bool {
		do {
			try await api.deletePlantEntry(plantEntryId: plantEntryId)
			errorPopupsState.presentSuccessPopup(text: "Plant entry deleted")
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
	func renamePlantEntry() async -> Bool {
		do {
			try await api.renamePlantEntry(plantEntryId: plantEntryId, newName: renamePlantEntryModalValue)
			errorPopupsState.presentSuccessPopup(text: "Plant entry renamed")
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
	
	func deleteReminder() async -> Bool {
		guard let reminderToDelete else {
			print("reminderToDelete is nil")
			return false
		}
		do {
			try await api.deleteReminder(reminderId: reminderToDelete)
			await errorPopupsState.presentSuccessPopup(text: "Reminder deleted")
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
			await errorPopupsState.presentSuccessPopup(text: "Event deleted")
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
