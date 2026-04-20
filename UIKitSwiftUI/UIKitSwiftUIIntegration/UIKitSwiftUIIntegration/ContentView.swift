import SwiftUI

struct ContentView: View {
	@State private var viewModel = ProfileViewModel()
	@State private var isDarkMode = false
	
	var body: some View {
		VStack {
			Toggle("Dark Mode", isOn: $isDarkMode)
				.padding()
			ProfileControllerWrapper(viewModel: viewModel)
				.ignoresSafeArea()
		}
		.preferredColorScheme(isDarkMode ? .dark : .light)
	}
}

#Preview {
    ContentView()
}
