import UIKit

class FullscreenImageViewController: UIViewController {
    
    @IBOutlet private var errorView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var retryButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var closeButton: UIButton!
        
    var imageUrl: String!
    
    override func viewDidLoad() {
        retryButton.addTarget(self, action: #selector(onRetryButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
                
        loadImage()
    }
    
    private func loadImage() {
        imageView.kf.setImage(
            with: URL(string: imageUrl),
            completionHandler: { [weak self] result in
                guard let self else { return }
                
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success:
                    self.errorView.isHidden = true
                case .failure:
                    self.errorView.isHidden = false
                }
            }
        )
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    @objc private func onRetryButtonTapped() {
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        
        loadImage()
    }
}
