import SwiftUI

public struct AsyncImageView : View {
	let url: String
	
	public init(url: String) {
		self.url = url
	}
	
	public var body: some View {
		AsyncImage(url: URL(string: url)) { image in
			image
				.resizable()
				.scaledToFit()
		} placeholder: {
			LoadingView()
		}
	}
}
