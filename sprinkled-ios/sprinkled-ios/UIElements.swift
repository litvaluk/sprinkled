import SwiftUI

struct SprinkledListSection<Content: View>: View {
	let headerText: String
	let content: () -> Content
	
	init(headerText: String, @ViewBuilder content: @escaping () -> Content) {
		self.headerText = headerText
		self.content = content
	}
	
	var body: some View {
		VStack(spacing: 7) {
			HStack {
				Text(headerText)
					.font(.headline)
					.foregroundColor(.secondary)
					.fontWeight(.semibold)
				Spacer()
			}
			content()
		}
	}
}

struct SprinkledListItem<Content: View>: View {
	let title: String
	@ViewBuilder var content: () -> Content
	
	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(.primary)
				.padding(15)
			Spacer()
			content()
		}
		.background(.thinMaterial)
		.cornerRadius(10)
	}
}

struct SprinkledListToggle: View {
	let title: String
	let isOn: Binding<Bool>
	
	var body: some View {
		SprinkledListItem(title: title) {
			Toggle(title, isOn: isOn)
				.tint(.sprinkledGreen)
				.padding(.trailing, 12)
				.labelsHidden()
		}
	}
}

struct SprinkledListMenuPicker: View {
	let title: String
	let options: [String]
	let selection: Binding<String?>
	
	init(title: String, options: [String], selection: Binding<String?>) {
		self.title = title
		self.options = options
		self.selection = selection
	}
	
	init(title: String, options: [String], selection: Binding<String>) {
		self.init(title: title, options: options, selection: Binding<String?>(selection))
	}
	
	var body: some View {
		Menu {
			Picker(title, selection: selection) {
				ForEach(options, id: \.self) { option in
					Text(option).tag(option as String?)
				}
			}
		} label: {
			SprinkledListItem(title: title) {
				if (options.isEmpty) {
					Text("Nothing to select")
						.padding(.trailing, 10)
						.foregroundColor(.gray)
				} else {
					if let unwrappedSelection = selection.wrappedValue {
						Text(unwrappedSelection)
							.foregroundColor(.gray)
					} else {
						ProgressView()
							.padding(.trailing, 1)
					}
					Image(systemName: "chevron.up.chevron.down")
						.resizable()
						.scaledToFit()
						.frame(width: 10, height: 10)
						.fontWeight(.semibold)
						.foregroundColor(.gray)
						.padding(.leading, 4)
						.padding(.trailing, 10)
				}
			}
		}
		.disabled(selection.wrappedValue == nil)
	}
}

struct SprinkledListNavigationLink<Value: Hashable>: View {
	let title: String
	let value: Value?
	
	init(title: String, value: Value?) {
		self.title = title
		self.value = value
	}
	
	init(title: String) {
		self.title = title
		self.value = nil
	}
	
	var body: some View {
		NavigationLink(value: value) {
			SprinkledListItem(title: title) {
				Image(systemName: "chevron.right")
					.resizable()
					.scaledToFit()
					.frame(width: 10, height: 10)
					.fontWeight(.semibold)
					.foregroundColor(.gray)
					.padding(.leading, 4)
					.padding(.trailing, 8)
			}
		}
	}
}

struct SprinkledListDatePicker: View {
	let title: String
	let selection: Binding<Date>
	let displayedComponents: DatePicker.Components
	
	var body: some View {
		SprinkledListItem(title: title) {
			DatePicker("Pick date", selection: selection, displayedComponents: displayedComponents)
				.datePickerStyle(.compact)
				.labelsHidden()
				.padding(.trailing, 8)
		}
	}
}

struct SprinkledButton: View {
	let text: String
	let action: () -> Void
	
	init(text: String, action: @escaping () -> Void) {
		self.text = text
		self.action = action
	}
	
	var body: some View {
		Button(role: .destructive) {
			action()
		} label: {
			HStack {
				Spacer()
				Text(text)
					.foregroundColor(.white)
					.padding(15)
				Spacer()
			}
			.background(Color.sprinkledGreen)
			.cornerRadius(10)
		}
	}
}

struct SprinkledListActionButton: View {
	let title: String
	let completedTitle: String
	let textPadding: CGFloat
	let action: () async -> Bool
	@State var isProcessing = false
	@State var completed: Bool? = nil
	
	init(title: String, completedTitle: String, textPadding: CGFloat = 6, action: @escaping () async -> Bool) {
		self.title = title
		self.completedTitle = completedTitle
		self.textPadding = textPadding
		self.action = action
	}
	
	var body: some View {
		if let completed {
			if (completed) {
				Text(completedTitle)
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundColor(.secondary)
					.padding(.trailing)
			} else {
				Text("Failed")
					.font(.footnote)
					.fontWeight(.medium)
					.foregroundColor(.secondary)
					.padding(.trailing)
			}
		} else if (isProcessing) {
			ProgressView()
				.padding(.trailing)
		} else {
			Button {
				isProcessing = true
				Task {
					if (await action()) {
						completed = true
					} else {
						completed = false
					}
				}
			} label: {
				ZStack {
					Text(title)
						.font(.subheadline)
						.foregroundColor(.white)
						.padding(textPadding)
						.background {
							Color.sprinkledGreen
								.cornerRadius(8)
						}
				}
				.padding(.trailing, 9)
			}
		}
	}
}
