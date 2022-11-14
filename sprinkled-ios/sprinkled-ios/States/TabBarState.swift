import SwiftUI

class TabBarState: ObservableObject {
	@Published var tappedSameCount = 0
	@Published var selection = 0
}
