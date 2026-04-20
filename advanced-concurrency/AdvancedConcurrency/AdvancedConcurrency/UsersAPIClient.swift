import Foundation

enum APIError: Error {
	case invalidResponse
	case emptyResults
}

protocol UsersAPIClientProtocol: Sendable {
	func fetchUser(id: Int) async throws -> User
}

struct UsersAPIClient: UsersAPIClientProtocol {
	private let session: URLSession
	private let decoder = JSONDecoder()
	
	private static let runtimeSeed = UUID().uuidString
	
	init(session: URLSession = .shared) {
		self.session = session
	}
	
	func fetchUser(id: Int) async throws -> User {
		var components = URLComponents(string: "https://randomuser.me/api/")!
		components.queryItems = [
			URLQueryItem(name: "seed", value: Self.runtimeSeed),
			URLQueryItem(name: "page", value: "\(id)"),
			URLQueryItem(name: "results", value: "1")
		]
		
		guard let url = components.url else {
			throw URLError(.badURL)
		}
		
		let (data, response) = try await session.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse,
			  200..<300 ~= httpResponse.statusCode else {
			throw APIError.invalidResponse
		}
		
		let decoded = try decoder.decode(RandomUserResponse.self, from: data)
		
		guard let dto = decoded.results.first else {
			throw APIError.emptyResults
		}
		
		return User (
			id: id,
			fullName: "\(dto.name.title) \(dto.name.first) \(dto.name.last)",
			email: dto.email,
			city: dto.location.city,
			avatarURL: URL(string: dto.picture.large)
		)
	}
}

struct RandomUserResponse : Decodable {
	let results: [RandomUserDTO]
}

struct RandomUserDTO: Decodable {
	let name: NameDTO
	let email: String
	let location: LocationDTO
	let picture: PictureDTO

	struct NameDTO: Decodable {
		let title: String
		let first: String
		let last: String
	}

	struct LocationDTO: Decodable {
		let city: String
	}

	struct PictureDTO: Decodable {
		let large: String
	}
}
