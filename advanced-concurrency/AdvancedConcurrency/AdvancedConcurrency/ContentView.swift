import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = UsersViewModel()
    var body: some View {
		NavigationView {
			VStack(spacing: 16) {
				HStack(spacing: 12) {
					Button("load 1...10") {
						viewModel.loadUsers(ids: Array(1...10))
					}
					.buttonStyle(.borderedProminent)
					Button("Reapeat 1...10") {
						viewModel.loadUsers(ids: Array(1...10))
					}
					.buttonStyle(.borderedProminent)
					Button("Cancel") {
						viewModel.cancelLoading()
					}
					.buttonStyle(.borderedProminent)
				}
				
				if viewModel.isLoading {
					ProgressView("Loading...")
				}

				if let errorMessage = viewModel.errorMessage {
					Text(errorMessage)
						.foregroundColor(.red)
				}

				List(viewModel.users) { user in
					VStack(alignment: .leading, spacing: 4) {
						Text(user.fullName)
							.font(.headline)

						Text(user.email)
							.font(.subheadline)

						Text(user.city)
							.font(.caption)
							.foregroundColor(.secondary)
					}
				}
			}
			.padding()
			.navigationTitle("Users")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Logs") {
						viewModel.printCacheLogs()
					}
				}
			}
		}
    }
}

#Preview {
    ContentView()
}
