import SwiftUI

struct OnboardingStep {
	let title: String
	let image: String
	let description: String
}

struct OnboardingView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: OnboardingViewModel
	
	var body: some View {
		VStack {
			TabView(selection: $vm.currentStep) {
				welcomeStepView()
					.tag(0)
				stepView(title: "Manage your plants", description: "Create teams, assign places and add your plants into them.", imageName: "Step2")
					.tag(1)
				stepView(title: "Discover and add plants", description: "Search for plants you want to add or find the next plant you would like to own. When you add a plant, you can set a recommended reminder plan.", imageName: "Step3")
					.tag(2)
				stepView(title: "See and edit your plants", description: "Browse the event history, set reminders and add photos of your plant.", imageName: "Step4")
					.tag(3)
				stepView(title: "Complete your tasks", description: "See your upcoming tasks and complete them when the time comes.", imageName: "Step5")
					.tag(4)
				notificationStepView()
					.tag(5)
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			.animation(.easeInOut(duration: 0.1), value: vm.currentStep)
			Spacer()
			HStack {
				ForEach(0..<vm.stepCount, id: \.self) { i in
					Circle()
						.frame(width: 8, height: 8)
						.foregroundColor(i == vm.currentStep ? .sprinkledGreen : .sprinkledDarkerGray)
						.animation(.easeInOut(duration: 0.1), value: vm.currentStep)
				}
			}
			.padding(15)
			SprinkledButton(text: vm.currentStep == vm.stepCount - 1 ? "Get Started" : "Next") {
				if (vm.currentStep < vm.stepCount - 1) {
					vm.currentStep += 1
				} else {
					vm.showOnboarding = false
				}
			}
		}
		.padding()
	}
	
	func welcomeStepView() -> some View {
		VStack {
			Text("Welcome!")
				.multilineTextAlignment(.center)
				.font(.title)
				.bold()
				.padding(.top, 30)
				.padding(.horizontal)
				.padding(.bottom, 20)
			Text("Whether you are a plant lover or you just need to keep your plants alive, Sprinkled is here for you.")
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
				.padding(.horizontal, 32)
				.padding(.bottom, 15)
			Spacer()
			Image("WelcomeIcon")
				.resizable()
				.scaledToFit()
				.padding(.horizontal, 80)
			Spacer()
		}
	}
	
	func stepView(title: String, description: String, imageName: String) -> some View {
		VStack {
			Text(title)
				.multilineTextAlignment(.center)
				.font(.title)
				.bold()
				.padding(.top, 30)
				.padding(.horizontal)
				.padding(.bottom, 20)
			Text(description)
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
				.padding(.horizontal, 32)
				.padding(.bottom, 15)
			Spacer()
			Image(imageName)
				.resizable()
				.scaledToFit()
				.padding(.horizontal, 30)
			Spacer()
		}
	}
	
	func notificationStepView() -> some View {
		VStack {
			Text("Notifications")
				.multilineTextAlignment(.center)
				.font(.title)
				.bold()
				.padding(.top, 30)
				.padding(.horizontal)
				.padding(.bottom, 20)
			Text("Please enable notifications, so you can be reminded and notified when another member of your team completes or adds an event.")
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
				.padding(.horizontal, 32)
				.padding(.bottom, 15)
			Spacer()
			VStack(spacing: 50) {
				Image(systemName: "bell")
					.resizable()
					.scaledToFit()
					.padding(.horizontal, 130)
				Button {
					vm.enableNotifications()
				} label: {
					Text("Enable notifications")
						.foregroundColor(.white)
						.padding(20)
						.background(Color.sprinkledGreen)
						.cornerRadius(10)
				}
			}
			Spacer()
		}
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(vm: OnboardingViewModel(errorPopupsState: ErrorPopupsState()))
	}
}
