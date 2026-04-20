import SwiftUI
import Kingfisher
import UIComponents

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Сторонняя библиотека:")
				.font(.title)
			
			KFImage(URL(string: "https://i.pinimg.com/1200x/0a/35/0f/0a350f7f28c250dc979e4c16d05ed078.jpg"))
				.resizable()
				.scaledToFit()
				.frame(width: 150, height: 260)
				.padding()
				.background(Color.gray.opacity(0.16))
				.cornerRadius(16)
			
			UserCardView(name: "Свой пакет:",
						 imageURL: "https://i.pinimg.com/736x/73/76/00/737600024bd677a21cc126cf744a6e9d.jpg")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
