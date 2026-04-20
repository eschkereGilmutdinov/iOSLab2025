import SwiftUI
import Observation

@Observable
final class ProfileViewModel {
	var profile = UserProfile(
		name: "Iskander Gilmutdinov",
		email: "iskander@gmail.com",
		avatar: "person.crop.circle.fill",
		isFollowing: false
	)
	
	func toggleFollow() {
		profile.isFollowing.toggle()
	}
}
