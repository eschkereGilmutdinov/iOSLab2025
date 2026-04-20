import XCTest
@testable import DependencyInjection

@MainActor
final class DependencyInjectionTests: XCTestCase {
	func test_loadUsers() async {
		let mockUsers = [
			User(id: 1, name: "Iskander", email: "iskander@gmail.com"),
			User(id: 2, name: "Ilya", email: "ilya@gmail.com")
		]
		
		let service = MockUsersService(result: .success(mockUsers))
		let viewModel = UsersViewModel(service: service)
		
		await viewModel.loadUsers()
		
		XCTAssertEqual(viewModel.users, mockUsers)
		XCTAssertNil(viewModel.errorMessage)
		XCTAssertFalse(viewModel.isEmpty)
		XCTAssertFalse(viewModel.isLoading)
	}
	
	func test_loadUsers_Error() async {
		let service = MockUsersService(result: .failure(UserServiceError.invalidResponse))
		let viewModel = UsersViewModel(service: service)
		
		await viewModel.loadUsers()
		
		XCTAssertTrue(viewModel.users.isEmpty)
		XCTAssertNotNil(viewModel.errorMessage)
		XCTAssertEqual(viewModel.errorMessage, UserServiceError.invalidResponse.localizedDescription)
		XCTAssertFalse(viewModel.isEmpty)
		XCTAssertFalse(viewModel.isLoading)
	}
	
	func test_loadUsers_Empty() async {
		let service = MockUsersService(result: .success([]))
		let viewModel = UsersViewModel(service: service)
		
		await viewModel.loadUsers()
		
		XCTAssertTrue(viewModel.users.isEmpty)
		XCTAssertNil(viewModel.errorMessage)
		XCTAssertTrue(viewModel.isEmpty)
		XCTAssertFalse(viewModel.isLoading)
	}
}
