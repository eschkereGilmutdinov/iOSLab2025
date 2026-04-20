import SwiftUI
import Observation

struct UsersView: View {
	@State private var viewModel: UsersViewModel
	
	init(service: UsersService = RealUsersService()) {
		_viewModel = State(wrappedValue: UsersViewModel(service: service))
	}
	
	var body: some View {
		NavigationStack {
			contentView
				.navigationTitle("Users")
		}
		.task {
			await viewModel.loadUsers()
		}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if viewModel.isLoading {
			loadingView
		} else if let errorMessage = viewModel.errorMessage {
			errorView(message: errorMessage)
		} else if viewModel.isEmpty {
			emptyView
		} else {
			usersListView
		}
	}
	
	private var usersListView: some View {
		List(viewModel.users) { user in
			VStack(alignment: .leading, spacing: 4) {
				Text(user.name)
					.font(.headline)
				Text(user.email)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}
		}
	}
	
	private var emptyView: some View {
		Text("Список пуст")
			.foregroundStyle(.secondary)
	}
	
	private var loadingView: some View {
		ProgressView("Загрузка...")
	}
	
	private func errorView(message: String) -> some View {
		VStack {
			Text("Ошибка")
				.font(.headline)
			Text(message)
				.foregroundStyle(.red)
				.multilineTextAlignment(.center)
		}
		.padding()
	}
}
