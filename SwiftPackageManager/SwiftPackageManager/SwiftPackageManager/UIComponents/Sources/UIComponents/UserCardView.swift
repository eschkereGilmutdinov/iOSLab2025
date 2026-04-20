import SwiftUI

public struct UserCardView: View {
	let name: String
	let imageURL: String
	
	public init(name: String, imageURL: String) {
		self.name = name
		self.imageURL = imageURL
	}
	
	public var body: some View {
		VStack(spacing: 12) {
			Text(name)
				.font(.title)
			AsyncImageView(url: imageURL)
				.frame(width: 150, height: 260)
				.padding()
				.background(Color.gray.opacity(0.16))
				.cornerRadius(16)
		}
	}
}
