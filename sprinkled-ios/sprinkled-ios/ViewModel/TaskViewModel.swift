import SwiftUI
import Collections

final class TaskViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var reminderMap: OrderedDictionary<String, [ReminderForTaskView]>? = nil
	@Published var navigationPath = NavigationPath()
	
	let dateFormatter: DateFormatter
	
	init() {
		dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d"
	}
	
	@MainActor
	func fetchReminders() async {
		var reminders: [ReminderForTaskView]
		do {
			reminders = try await api.fetchReminders()
		} catch is ExpiredRefreshToken {
			print("⌛️ Refresh token expired.")
			return
		} catch {
			print("❌ Error while fetching plants.")
			return
		}
		reminders = reminders.filter { $0.date > .now }
		reminderMap = OrderedDictionary.init(grouping: reminders) { reminder in
			dateFormatter.string(from: reminder.date)
		}
		
	}
}
