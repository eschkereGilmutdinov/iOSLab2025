import UIKit

final class ProfileViewController: UIViewController {
	private var profile: UserProfile
	private let onFollowTap: (() -> Void)?
	
	private let cardView = ProfileCardView()
	
	init(profile: UserProfile, onFollowTap: (() -> Void)?) {
		self.profile = profile
		self.onFollowTap = onFollowTap
		super.init(nibName: nil, bundle: nil)
	}
	
	required init? (coder: NSCoder) {
		fatalError()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupLayout()
		configure()
	}
	
	func update(profile: UserProfile) {
		self.profile = profile
		configure()
	}
	
	private func setupView() {
		view.backgroundColor = .systemBackground
		cardView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cardView)
		
		cardView.addSubview(avatarImageView)
		cardView.addSubview(nameLabel)
		cardView.addSubview(emailLabel)
		cardView.addSubview(followButton)
		
		followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
	}
	
	private func setupLayout() {
		NSLayoutConstraint.activate([
			cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

			avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
			avatarImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
			avatarImageView.widthAnchor.constraint(equalToConstant: 100),
			avatarImageView.heightAnchor.constraint(equalToConstant: 100),

			nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
			nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
			nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

			emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
			emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
			emailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

			followButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24),
			followButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
			followButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
			followButton.heightAnchor.constraint(equalToConstant: 50),
			followButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -32)
		])
	}
	
	private func configure() {
		avatarImageView.image = UIImage(systemName: profile.avatar)
		nameLabel.text = profile.name
		emailLabel.text = profile.email
		updateButton()
	}
	
	private func updateButton() {
		let title = profile.isFollowing ? "Following" : "Follow"
		followButton.setTitle(title, for: .normal)
		
		if profile.isFollowing {
			followButton.backgroundColor = .systemGray5
			followButton.setTitleColor(.label, for: .normal)
		} else {
			followButton.backgroundColor = .systemBlue
			followButton.setTitleColor(.white, for: .normal)
		}
	}
	
	private let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.tintColor = .systemBlue
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 50
		imageView.backgroundColor = .tertiarySystemBackground
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 24)
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()
	
	private let emailLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 16)
		label.textColor = .secondaryLabel
		label.textAlignment = .center
		return label
	}()
	
	private let followButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 14
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
		return button
	}()
	
	@objc
	private func didTapFollow() {
		onFollowTap?()
	}
}
