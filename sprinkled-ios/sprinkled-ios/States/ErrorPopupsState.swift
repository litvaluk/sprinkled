import SwiftUI

class ErrorPopupsState: ObservableObject {
	@Published var showConnectionError = false
	@Published var showGenericError = false
}
