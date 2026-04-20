import Foundation

final class RealUsersService : UsersService {
	func fetchUsers() async throws -> [User] {
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
			throw UserServiceError.invalidURL
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let httpResponce = response as? HTTPURLResponse,
			  200...299 ~= httpResponce.statusCode else {
			throw UserServiceError.invalidResponse
		}
		
		return try JSONDecoder().decode([User].self, from: data)
	}
}

enum UserServiceError: LocalizedError, Equatable {
	case invalidURL
	case invalidResponse
	case unknown
	
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "Некоректный URL"
		case .invalidResponse:
			return "Ошибка сервера"
		case .unknown:
			return "Неизвестная ошибка"
		}
	}
}
