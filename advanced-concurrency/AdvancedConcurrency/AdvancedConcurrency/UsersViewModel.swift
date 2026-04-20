import Foundation
import Combine

@MainActor
final class UsersViewModel: ObservableObject {
	@Published private(set) var users: [User] = []
	@Published private(set) var isLoading = false
	@Published var errorMessage: String?
	
	private let repository: UsersRepositoryProtocol
	private var loadTask: Task<Void, Never>?
	
	init(repository: UsersRepositoryProtocol = UsersRepository()) {
		self.repository = repository
	}
	
	func loadUsers(ids: [Int]) {
		cancelLoading()

		isLoading = true
		errorMessage = nil

		loadTask = Task {
			do {
				let loadedUsers = try await repository.users(ids: ids)
				try Task.checkCancellation()

				self.users = loadedUsers
				self.isLoading = false
			} catch is CancellationError {
				self.isLoading = false
			} catch {
				self.errorMessage = error.localizedDescription
				self.isLoading = false
			}
		}
	}
	
	func loadUser(id: Int) {
		cancelLoading()

		isLoading = true
		errorMessage = nil

		loadTask = Task {
			do {
				let user = try await repository.user(id: id)
				try Task.checkCancellation()

				if let index = self.users.firstIndex(where: { $0.id == user.id }) {
					self.users[index] = user
				} else {
					self.users.append(user)
					self.users.sort { $0.id < $1.id }
				}

				self.isLoading = false
			} catch is CancellationError {
				self.isLoading = false
			} catch {
				self.errorMessage = error.localizedDescription
				self.isLoading = false
			}
		}
	}
	
	func cancelLoading() {
		loadTask?.cancel()
		loadTask = nil
	}

	func printCacheLogs() {
		Task {
			let logs = await repository.cacheLogs()
			print("=== CACHE LOGS ===")
			logs.forEach { print($0) }
		}
	}
}
