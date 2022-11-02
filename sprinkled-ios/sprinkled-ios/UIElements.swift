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

struct SprinkledListToggle: View {
	let title: String
	let isOn: Binding<Bool>
	
	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(.primary)
				.padding(.vertical, 15)
			Spacer()
			Toggle(title, isOn: isOn)
				.tint(.sprinkledGreen)
				.padding(.trailing, 12)
				.labelsHidden()
		}
		.padding(.leading, 15)
		.background(.thinMaterial)
		.cornerRadius(10)
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
			HStack {
				Text(title)
					.foregroundColor(.primary)
				Spacer()
				Text(selection.wrappedValue)
					.foregroundColor(.gray)
				Image(systemName: "chevron.up.chevron.down")
					.resizable()
					.scaledToFit()
					.frame(width: 10, height: 10)
					.fontWeight(.semibold)
					.foregroundColor(.gray)
					.padding(.leading, 4)
			}
			.padding(15)
			.background(.thinMaterial)
			.cornerRadius(10)
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
			HStack {
				Text(title)
					.foregroundColor(.primary)
				Spacer()
				Image(systemName: "chevron.right")
					.resizable()
					.scaledToFit()
					.frame(width: 10, height: 10)
					.fontWeight(.semibold)
					.foregroundColor(.gray)
					.padding(.leading, 4)
			}
			.padding(15)
			.background(.thinMaterial)
			.cornerRadius(10)
		}
	}
}
