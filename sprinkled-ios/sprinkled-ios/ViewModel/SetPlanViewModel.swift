import SwiftUI

final class SetPlanViewModel: ObservableObject {
	@Inject var api: APIProtocol
	
	@Published var planSelection: Int
	@Published var reminderTime: Date = Date()
	
	private let errorPopupsState: ErrorPopupsState
	
	let plantEntryId: Int
	let plantEntryName: String
	let plans: [Plan]
	
	init(plantEntryId: Int, plantEntryName: String, plans: [Plan], errorPopupsState: ErrorPopupsState) {
		self.plantEntryId = plantEntryId
		self.plantEntryName = plantEntryName
		self.plans = plans
		self.planSelection = plans.first!.id
		self.errorPopupsState = errorPopupsState
	}
	
	func setPlan() async -> Bool {
		let hour = reminderTime.utcHour()
		let minute = reminderTime.utcMinute()
		do {
			try await api.setPlan(plantEntryId: plantEntryId, planId: planSelection, hour: hour, minute: minute)
			await errorPopupsState.presentSuccessPopup(text: "Plant entry added")
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
