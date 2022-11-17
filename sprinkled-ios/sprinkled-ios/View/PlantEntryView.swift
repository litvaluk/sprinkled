import SwiftUI
import Kingfisher
import Shimmer

enum PlantEntryMenuAction: Hashable, Equatable {
	case addEvent(PlantEntry)
	case addReminder(PlantEntry)
}

enum PlantEntryReminderMenuAction: Hashable, Equatable {
	case edit(PlantEntry, Reminder)
}

enum PlantEntryEventMenuAction: Hashable, Equatable {
	case edit(PlantEntry, Event)
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
		.modal(title: "Are you sure?", showModal: $vm.reminderToDelete.mappedToBool()) {
			Text("This action will delete the chosen reminder.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await vm.deleteReminder()) {
						await vm.fetchPlantEntry()
					}
					withAnimation(.easeOut(duration: 0.07)) {
						vm.reminderToDelete = nil
					}
				}
			} label: {
				Text("Delete")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.tint(.sprinkledRed)
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.reminderToDelete = nil
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.modal(title: "Are you sure?", showModal: $vm.eventToDelete.mappedToBool()) {
			Text("This action will delete the chosen event.")
				.font(.title3)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		} buttons: {
			Button {
				Task {
					if (await vm.deleteEvent()) {
						await vm.fetchPlantEntry()
					}
					withAnimation(.easeOut(duration: 0.07)) {
						vm.eventToDelete = nil
					}
				}
			} label: {
				Text("Delete")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.tint(.sprinkledRed)
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
			Button {
				withAnimation(.easeOut(duration: 0.07)) {
					vm.eventToDelete = nil
				}
			} label: {
				Text("Cancel")
					.frame(maxWidth: .infinity, minHeight: 28)
			}
			.buttonStyle(.borderedProminent)
			.cornerRadius(10)
		}
		.sheet(isPresented: $vm.showImagePickerChoiceSheet) {
			VStack(spacing: 10) {
				Button {
					vm.showImagePickerChoiceSheet = false
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						vm.showCameraImagePicker = true
					}
				} label: {
					Text("Camera")
						.frame(maxWidth: .infinity, minHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
				Button {
					vm.showImagePickerChoiceSheet = false
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
						vm.showPhotoLibraryImagePicker = true
					}
				} label: {
					Text("Photo library")
						.frame(maxWidth: .infinity, minHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
			}
			.padding()
			.presentationDetents([.height(150)])
			.presentationDragIndicator(.visible)
		}
		.sheet(isPresented: $vm.showPhotoLibraryImagePicker) {
			ImagePicker(sourceType: .photoLibrary, selectedImage: $vm.image)
				.ignoresSafeArea()
		}
		.fullScreenCover(isPresented: $vm.showCameraImagePicker) {
			ImagePicker(sourceType: .camera, selectedImage: $vm.image)
				.ignoresSafeArea()
		}
		.onChange(of: vm.image) { image in
			Task {
				vm.selectedSection = .gallery
				await vm.savePhoto()
				await vm.fetchPlantEntry()
			}
		}
		.task {
			await vm.fetchPlantEntry()
		}
	}
}

struct PlantEntryHeaderView: View {
	@StateObject var vm: PlantEntryViewModel
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	
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
					Button {
						vm.showImagePickerChoiceSheet = true
					} label: {
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
					AddEventView(vm: AddEventViewModel(plantEntryId: plantEntry.id, plantEntryName: plantEntry.name, errorPopupsState: errorPopupsState))
				case PlantEntryMenuAction.addReminder(let plantEntry):
					AddReminderView(vm: AddReminderViewModel(plantEntryId: plantEntry.id, plantEntryName: plantEntry.name, errorPopupsState: errorPopupsState))
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
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	
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
						PlantEntryListItem(title: "\(event.action.type)".capitalizedFirstLetter(), subtitle: "\(event.user!.username)", action: event.action.type, date: event.date) {
							NavigationLink(value: PlantEntryEventMenuAction.edit(plantEntry, event)) {
								Text("Edit")
								Image(systemName: "slider.horizontal.3")
							}
							Button {
								vm.eventToDelete = event.id
							} label: {
								Text("Delete")
								Image(systemName: "trash")
							}
						}
					}
				} else {
					ForEach(0..<3) { _ in
						PlantEntryListItem(title: .placeholder(8), subtitle: .placeholder(6), action: nil, date: .placeholder) {
							EmptyView()
						}
						.redactedShimmering()
					}
				}
			}
			.navigationDestination(for: PlantEntryEventMenuAction.self) { action in
				switch(action) {
				case .edit(let plantEntry, let event):
					EditEventView(vm: EditEventViewModel(plantEntryId: plantEntry.id, plantEntryName: plantEntry.name, event: event, errorPopupsState: errorPopupsState))
				}
			}
		case .reminders:
			VStack (spacing: 8) {
				if let plantEntry = vm.plantEntry {
					ForEach(plantEntry.reminders) { reminder in
						let subtitle = reminder.period == 0 ? "One time" : "Every \(reminder.period) days"
						PlantEntryListItem(title: "\(reminder.action.type)".capitalizedFirstLetter(), subtitle: subtitle, action: reminder.action.type, date: reminder.date) {
							NavigationLink(value: PlantEntryReminderMenuAction.edit(plantEntry, reminder)) {
								Text("Edit")
								Image(systemName: "slider.horizontal.3")
							}
							Button {
								vm.reminderToDelete = reminder.id
							} label: {
								Text("Delete")
								Image(systemName: "trash")
							}
						}
					}
				} else {
					ForEach(0..<3) { _ in
						PlantEntryListItem(title: .placeholder(8), subtitle: .placeholder(6), action: nil, date: .placeholder) {
							EmptyView()
						}
						.redactedShimmering()
					}
				}
			}
			.navigationDestination(for: PlantEntryReminderMenuAction.self) { action in
				switch(action) {
				case .edit(let plantEntry, let reminder):
					EditReminderView(vm: EditReminderViewModel(plantEntryId: plantEntry.id, plantEntryName: plantEntry.name, reminder: reminder, errorPopupsState: errorPopupsState))
				}
			}
		case .gallery:
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
				if let plantEntry = vm.plantEntry {
					ForEach(plantEntry.pictures) { picture in
						Button {
							pictureViewState.set(selection: picture.id, pictures: plantEntry.pictures, onDelete: {
								Task {
									await vm.fetchPlantEntry()
								}
							})
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

struct PlantEntryListItem<Content: View>: View {
	let title: String
	let subtitle: String
	let action: String?
	let date: Date
	let content: () -> Content
	
	init(title: String, subtitle: String, action: String?, date: Date, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.subtitle = subtitle
		self.action = action
		self.date = date
		self.content = content
	}
	
	var body: some View {
		ZStack {
			Color.sprinkledGray
			HStack {
				Color.sprinkledDarkerGray
					.aspectRatio(1, contentMode: .fit)
					.frame(width: 50, height: 50)
					.cornerRadius(7)
					.overlay {
						if let action {
							Image("\(action)ActionIcon")
								.resizable()
								.scaledToFit()
								.padding(5)
						}
					}
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
				.padding(.horizontal, 5)
				Menu {
					content()
				} label: {
					Image(systemName: "ellipsis")
						.padding(.trailing, 10)
				}
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
		NavigationStack {
			PlantEntryView(vm: PlantEntryViewModel(plantEntryId: 1, errorPopupsState: ErrorPopupsState()))
				.environmentObject(PictureViewState(errorPopupsState: ErrorPopupsState()))
		}
	}
}
