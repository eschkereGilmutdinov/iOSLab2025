import SwiftUI

struct ProfileControllerWrapper: UIViewControllerRepresentable {
	@Bindable var viewModel: ProfileViewModel
	
	func makeUIViewController(context: Context) -> ProfileViewController {
		ProfileViewController(profile: viewModel.profile, onFollowTap: viewModel.toggleFollow)
	}
	
	func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
		uiViewController.update(profile: viewModel.profile)
	}
}
