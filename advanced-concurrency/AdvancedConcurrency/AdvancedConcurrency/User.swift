import Foundation

struct User : Identifiable, Hashable, Sendable {
	let id: Int
	let fullName: String
	let email: String
	let city: String
	let avatarURL: URL?
}
