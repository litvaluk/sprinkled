import SwiftUI

struct SprinkledTextFieldStyle: TextFieldStyle {
	@FocusState private var textFieldFocused: Bool
	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.padding(15)
			.background(.thinMaterial)
			.cornerRadius(10)
			.focused($textFieldFocused)
			.onTapGesture {
				textFieldFocused = true
			}
	}
}
