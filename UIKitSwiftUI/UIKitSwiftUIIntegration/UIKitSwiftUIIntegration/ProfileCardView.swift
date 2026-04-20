import UIKit

final class ProfileCardView: UIView {
	override init (frame: CGRect) {
		super.init(frame: frame)
		setupStyle()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupStyle()
	}
	
	private func setupStyle() {
		backgroundColor = .secondarySystemBackground
		layer.cornerRadius = 24
		layer.cornerCurve = .continuous
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.08
		layer.shadowOffset = CGSize(width: 0, height: 6)
		layer.shadowRadius = 12
	}
}
