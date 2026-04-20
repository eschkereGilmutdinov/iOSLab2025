import Foundation
import Observation

@MainActor
@Observable
final class UsersViewModel {
	var users: [User] = []
	var isLoading = false
	var errorMessage: String?
	var isEmpty = false
	
	private let service: UsersService
	
	init(service: UsersService) {
		self.service = service
	}
	
	func loadUsers() async {
		isLoading = true
		errorMessage = nil
		isEmpty = false
		
		do {
			let fetchedUsers = try await service.fetchUsers()
			users = fetchedUsers
			isEmpty = fetchedUsers.isEmpty
		} catch {
			users = []
			errorMessage = error.localizedDescription
			isEmpty = false
		}
		
		isLoading = false
	}
}
