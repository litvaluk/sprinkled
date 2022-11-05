import SwiftUI
import Kingfisher
import Shimmer

enum PlantEntryMenuAction: Hashable, Equatable {
	case addEvent(PlantEntry)
	case addReminder(PlantEntry)
	case addPhoto
}

struct PlantEntryView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: PlantEntryViewModel
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			ScrollView {
				VStack {
					PlantEntryHeaderView(vm: vm)
					PlantEntryContent(vm: vm)
						.padding(.horizontal)
				}
			}
			.toolbar(.hidden)
			.ignoresSafeArea(.all, edges: [.top])
		}
		.overlay(alignment: .topLeading) {
			Button {
				self.presentationMode.wrappedValue.dismiss()
			} label: {
				Image(systemName: "chevron.left")
					.resizable()
					.scaledToFit()
					.frame(width: 16, height: 19)
					.fontWeight(.medium)
					.padding([.top], 12)
					.padding([.leading], 7)
			}
		}
		.task {
			await vm.fetchPlantEntry()
		}
	}
}

struct PlantEntryHeaderView: View {
	@StateObject var vm: PlantEntryViewModel
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GeometryReader { gr in
				if let pictureUrl = vm.plantEntry?.headerPictureUrl {
					if (gr.frame(in: .global).minY <= 0) {
						KFImage(URL(string: pictureUrl)!)
							.resizable()
							.scaledToFill()
							.frame(width: gr.size.width, height: gr.size.height)
							.offset(y: gr.frame(in: .global).minY/9)
							.clipped()
					} else {
						KFImage(URL(string: pictureUrl)!)
							.resizable()
							.scaledToFill()
							.frame(width: gr.size.width, height: gr.size.height + gr.frame(in: .global).minY)
							.clipped()
							.offset(y: -gr.frame(in: .global).minY)
					}
				} else {
					Rectangle()
						.foregroundColor(.sprinkledGray)
						.shimmering()
						.frame(width: gr.size.width, height: gr.frame(in: .global).minY <= 0 ? gr.size.height : gr.size.height + gr.frame(in: .global).minY)
						.offset(y: gr.frame(in: .global).minY <= 0 ? 0 : -gr.frame(in: .global).minY)
				}
			}
			.frame(height: 200)
		}
		HStack {
			VStack(alignment: .leading) {
				Text(vm.plantEntry?.name ?? .placeholder(10))
					.foregroundColor(.primary)
					.font(.title)
					.redactedShimmering(if: vm.plantEntry == nil)
				Text(vm.plantEntry?.name ?? .placeholder(10))
					.foregroundColor(.primary)
					.font(.title3)
					.redactedShimmering(if: vm.plantEntry == nil)
			}
			Spacer()
			Menu {
				if let plantEntry = vm.plantEntry {
					NavigationLink(value: PlantEntryMenuAction.addEvent(plantEntry)) {
						Text("Add event")
					}
					NavigationLink(value: PlantEntryMenuAction.addReminder(plantEntry)) {
						Text("Add reminder")
					}
					NavigationLink(value: PlantEntryMenuAction.addPhoto) {
						Text("Add photo")
					}
				}
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.frame(width: 60, height: 60)
						.foregroundColor(.sprinkledGreen)
					Image(systemName: "plus")
						.resizable()
						.foregroundColor(.white)
						.fontWeight(.medium)
						.frame(width: 30, height: 30)
				}
			}
			.disabled(vm.plantEntry == nil)
			.navigationDestination(for: PlantEntryMenuAction.self) { action in
				switch (action) {
				case PlantEntryMenuAction.addEvent(let plantEntry):
					AddEventView(vm: AddEventViewModel(plantEntryId: plantEntry.id, plantEntryName: plantEntry.name))
				case PlantEntryMenuAction.addReminder(let plantEntry):
					AddReminderView(vm: AddReminderViewModel(plantEntryId: plantEntry.id, plantEntryName: plantEntry.name))
				case PlantEntryMenuAction.addPhoto:
					Text("Take photo [\(vm.plantEntryId)]")
				}
			}
		}
		.padding(.horizontal)
	}
}

struct PlantEntryContent: View {
	@Namespace var namespace
	@StateObject var vm: PlantEntryViewModel
	@EnvironmentObject var pictureViewState: PictureViewState
	
	var body: some View {
		HStack() {
			ForEach(PlantEntrySection.allCases, id: \.self) { section in
				ZStack {
					if (vm.selectedSection == section) {
						RoundedRectangle(cornerRadius: 7)
							.foregroundColor(.sprinkledGreen)
							.matchedGeometryEffect(id: "selection", in: namespace)
					}
					Text(section.rawValue)
						.foregroundColor(vm.selectedSection == section ? .white : .primary)
						.frame(maxWidth: .infinity)
						.frame(height: 30)
				}
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.15)) {
						vm.selectedSection = section
					}
				}
			}
		}
		.padding(6)
		.background {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(.sprinkledGray)
		}
		switch(vm.selectedSection) {
		case .history:
			VStack (spacing: 8) {
				if let plantEntry = vm.plantEntry {
					ForEach(plantEntry.events) { event in
						PlantEntryListItem(title: "\(event.action.type)".capitalizedFirstLetter(), subtitle: "\(event.user.username)", date: event.date)
					}
				} else {
					ForEach(0..<3) { _ in
						PlantEntryListItem(title: .placeholder(8), subtitle: .placeholder(6), date: .placeholder)
							.redactedShimmering()
					}
				}
			}
		case .reminders:
			VStack (spacing: 8) {
				if let plantEntry = vm.plantEntry {
					ForEach(plantEntry.reminders) { reminder in
						let subtitle = reminder.period == 0 ? "One time" : "Every \(reminder.period) days"
						PlantEntryListItem(title: "\(reminder.action.type)".capitalizedFirstLetter(), subtitle: subtitle, date: reminder.date)
					}
				} else {
					ForEach(0..<3) { _ in
						PlantEntryListItem(title: .placeholder(8), subtitle: .placeholder(6), date: .placeholder)
							.redactedShimmering()
					}
				}
			}
		case .gallery:
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
				if let plantEntry = vm.plantEntry {
					ForEach(plantEntry.pictures) { picture in
						Button {
							pictureViewState.set(selection: picture.id, pictures: plantEntry.pictures)
						} label: {
							GalleryItem(user: "\(picture.userId)", date: picture.createdAt, pictureUrl: picture.url)
						}
					}
				} else {
					ForEach(0..<5) { i in
						GalleryItem(user: .placeholder(6), date: .placeholder)
							.redactedShimmering()
					}
				}
			}
		}
	}
}

struct PlantEntryListItem: View {
	let title: String
	let subtitle: String
	let date: Date
	
	var body: some View {
		ZStack {
			Color.sprinkledGray
			HStack {
				RoundedRectangle(cornerRadius: 7)
					.foregroundColor(.gray)
					.frame(width: 50, height: 50)
					.padding(5)
				VStack(alignment: .leading) {
					Text(title)
						.fontWeight(.medium)
					Text(subtitle)
				}
				Spacer()
				VStack(alignment: .trailing) {
					Spacer()
					Text(date.toString(.MMMdy))
						.font(.subheadline)
					Text(date.toString(.HHmm))
						.font(.subheadline)
					Spacer()
				}
				.padding(.trailing, 5)
			}
		}
		.cornerRadius(10)
	}
}

struct GalleryItem: View {
	let user: String
	let date: Date
	let pictureUrl: String?
	
	init(user: String, date: Date, pictureUrl: String? = nil) {
		self.user = user
		self.date = date
		self.pictureUrl = pictureUrl
	}
	
	var body: some View {
		ZStack {
			Color.clear
				.aspectRatio(1, contentMode: .fill)
				.clipped()
				.overlay {
					if let pictureUrl {
						KFImage(URL(string: pictureUrl)!)
							.resizable()
							.scaledToFill()
					}
				}
			VStack {
				Spacer()
				HStack {
					VStack(alignment: .leading) {
						Text(user)
							.font(.caption2)
							.foregroundColor(.black)
						Text(date.toString(.MMMdy))
							.font(.caption2)
							.foregroundColor(.black)
						Text(date.toString(.HHmm))
							.font(.caption2)
							.foregroundColor(.black)
					}
					Spacer()
				}
			}
			.padding(6)
		}
		.cornerRadius(10)
	}
}

struct PlantEntryView_Previews: PreviewProvider {
	static var previews: some View {
		PlantEntryView(vm: PlantEntryViewModel(plantEntryId: 1))
			.environmentObject(PictureViewState())
	}
}
