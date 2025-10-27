import UIKit
import Kingfisher

class BreedImagesViewController: UIViewController {
    
    @IBOutlet private var errorView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var retryButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    private let apiClient = DogAPIClient()

    var breedName: String!
    private var breedImageUrls: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = breedName
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        retryButton.addTarget(self, action: #selector(onRetryButtonTapped), for: .touchUpInside)

        loadBreedImages()
    }
    
    private func loadBreedImages() {
        apiClient.fetchBreedImages(breed: breedName) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let breedImageUrls):
                    self.breedImageUrls = breedImageUrls
                    self.errorView.isHidden = true
                    
                    self.collectionView.reloadData()
                case .failure:
                    self.errorView.isHidden = false
                }
            }
        }
    }
    
    @objc private func onRetryButtonTapped() {
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        
        loadBreedImages()
    }
}

extension BreedImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        breedImageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: BreedImageCollectionViewCell.self),
            for: indexPath
        ) as! BreedImageCollectionViewCell
        
        cell.breedImageView.kf.setImage(
            with: URL(string: breedImageUrls![indexPath.row]),
            placeholder: UIImage(named: "placeholder")
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let fullscreenImageViewController = UIStoryboard(
            name: String(describing: FullscreenImageViewController.self),
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: FullscreenImageViewController.self)
        ) as! FullscreenImageViewController
        
        fullscreenImageViewController.imageUrl = breedImageUrls![indexPath.row]

        present(fullscreenImageViewController, animated: true)
    }
}
