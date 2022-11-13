import SwiftUI

class TabBarState: ObservableObject {
	@Published var tappedSameCount = 0
	@Published var selection = 0
	
	var handler: Binding<Int> { Binding(
		get: { self.selection },
		set: {
			if ($0 == self.selection) {
				self.tappedSameCount += 1
			} else {
				self.tappedSameCount = 0
			}
			self.selection = $0
		}
	)}
}
