import Foundation

struct User: Identifiable, Decodable, Equatable {
	let id: Int
	let name: String
	let email: String
}
