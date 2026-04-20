import Foundation

protocol UsersService {
	func fetchUsers() async throws -> [User]
}
