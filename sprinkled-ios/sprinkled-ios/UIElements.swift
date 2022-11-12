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
					.font(.subheadline)
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
	let selection: Binding<String>
	
	var body: some View {
		Menu {
			Picker(title, selection: selection) {
				ForEach(options, id: \.self) { option in
					Text(option).tag(option)
				}
			}
		} label: {
			SprinkledListItem(title: title) {
				Text(selection.wrappedValue)
					.foregroundColor(.gray)
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
