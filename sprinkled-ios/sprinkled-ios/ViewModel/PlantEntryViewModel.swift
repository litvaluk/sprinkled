import SwiftUI

final class PlantEntryViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var plantEntry: PlantEntry?
	@Published var selectedSection: PlantEntrySection = .history
	@Published var loading = false
	@Published var reminderToDelete: Int? = nil
	@Published var eventToDelete: Int? = nil
	
	let plantEntryId: Int

	init(plantEntryId: Int) {
		self.plantEntryId = plantEntryId
	}
	
	@MainActor
	func fetchPlantEntry() async {
		loading = true
		defer { loading = false }
		do {
			plantEntry = try await api.fetchPlantEntry(plantEntryId: plantEntryId)
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while fetching plants.")
		}
	}
	
	func deleteReminder() async -> Bool {
		guard let reminderToDelete else {
			print("eventToDelete is nil")
			return false
		}
		do {
			try await api.deleteReminder(reminderId: reminderToDelete)
			return true
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while removing reminder.")
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
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
		} catch {
			print("❌ Error while removing event.")
		}
		return false
	}
}

enum PlantEntrySection : String, CaseIterable {
	case history = "History"
	case reminders = "Reminders"
	case gallery = "Gallery"
}
