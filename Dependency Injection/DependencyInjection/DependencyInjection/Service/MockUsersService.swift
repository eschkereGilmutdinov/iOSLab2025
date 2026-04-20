import Foundation

final class MockUsersService: UsersService {
	var result: Result<[User], Error>
	
	init(result: Result<[User], Error>) {
		self.result = result
	}
	
	func fetchUsers() async throws -> [User] {
		switch result {
		case .success(let users):
			return users
		case .failure(let error):
			throw error
		}
	}
}
