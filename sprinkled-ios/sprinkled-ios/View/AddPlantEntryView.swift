import SwiftUI

struct AddPlantEntryView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: AddPlantEntryViewModel
	
    var body: some View {
		GeometryReader { gr in
			ScrollView([]) {
				VStack(alignment: .center) {
					HStack(spacing: 0) {
						Button {
							presentationMode.wrappedValue.dismiss()
						} label: {
							Text("Cancel")
								.font(.title3)
						}
						Spacer()
					}
					HStack(spacing: 0) {
						Text("Add plant entry")
							.font(.largeTitle)
							.fontWeight(.bold)
						Spacer()
					}
					.padding(.top, 4)
					Button {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
							vm.showImagePickerChoiceSheet = true
						}
					} label: {
						ZStack(alignment: .bottomTrailing) {
							Color.clear
								.overlay {
									Image(uiImage: vm.image)
										.resizable()
										.scaledToFill()
									if (!vm.imagePicked) {
										Text("Choose/take\na photo")
											.multilineTextAlignment(.center)
									}
								}
							if (!vm.imagePicked) {
								Image("ChoosePhotoIcon")
									.resizable()
									.frame(width: 30, height: 30)
									.padding(10)
							}
						}
						.onChange(of: vm.image) { _ in
							vm.imagePicked = true
						}
						.cornerRadius(15)
						.aspectRatio(1, contentMode: .fit)
						.padding(.horizontal, 60)
					}
					.tint(.black)
					Text(vm.plant.commonName)
						.foregroundColor(.primary)
						.font(.title)
					Text(vm.plant.latinName)
						.foregroundColor(.primary)
						.font(.title3)
					Group {
						TextField("Name", text: $vm.name)
							.textFieldStyle(SprinkledTextFieldStyle())
							.autocorrectionDisabled()
							.textInputAutocapitalization(.never)
						SprinkledListMenuPicker(title: "Team", options: vm.getTeamOptions(), selection: $vm.teamSelection)
						SprinkledListMenuPicker(title: "Place", options: vm.getPlaceOptions(), selection: $vm.placeSelection)
							.onChange(of: vm.teamSelection) { _ in
								vm.updatePlaceSelection()
							}
						if (!vm.errorMessage.isEmpty) {
							Text("\(vm.errorMessage)")
								.multilineTextAlignment(.center)
								.foregroundColor(.red)
						}
					}
					Spacer()
					if (vm.isProcessing) {
						ProgressView()
							.scaleEffect(1.5)
							.padding()
					} else {
						SprinkledButton(text: "Add") {
							Task {
								if (await vm.createPlantEntry()) {
									presentationMode.wrappedValue.dismiss()
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
										vm.setupPlanPresented.wrappedValue = true
									}
								}
							}
						}
					}
				}
				.padding()
				.frame(minHeight: gr.size.height)
				.sheet(isPresented: $vm.showImagePickerChoiceSheet) {
					VStack(spacing: 10) {
						Button {
							vm.showImagePickerChoiceSheet = false
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
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
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
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
				.task {
					await vm.fetchTeamSummaries()
				}
			}
			.frame(width: gr.size.width)
			.ignoresSafeArea(.keyboard)
		}
    }
}

struct AddPlantEntryView_Previews: PreviewProvider {
    static var previews: some View {
		AddPlantEntryView(vm: AddPlantEntryViewModel(plant: TestData.plants[0], errorPopupsState: ErrorPopupsState(), setupPlanPresented: .constant(false), lastCreatedPlantEntry: .constant(nil)))
    }
}
