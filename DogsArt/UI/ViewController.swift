import UIKit

class ViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: UIView!
    @IBOutlet private var retryButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let apiClient = DogAPIClient()
    private var breeds: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Все породы"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: String(describing: BreedTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: BreedTableViewCell.self)
        )
        
        retryButton.addTarget(self, action: #selector(onRetryButtonTapped), for: .touchUpInside)

        loadBreeds()
    }
    
    private func loadBreeds() {
        apiClient.fetchAllBreeds { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.activityIndicator.stopAnimating()

                switch result {
                case .success(let breeds):
                    self.errorView.isHidden = true
                    self.breeds = Array(breeds.keys)
                    
                    self.tableView.reloadData()
                case .failure:
                    self.errorView.isHidden = false
                }
            }
        }
    }
    
    @objc private func onRetryButtonTapped() {
        errorView.isHidden = true
        activityIndicator.stopAnimating()
        
        loadBreeds()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let breed = breeds![indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: BreedTableViewCell.self),
            for: indexPath
        ) as! BreedTableViewCell
        
        cell.setup(breedName: breed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let breedImagesViewController = UIStoryboard(
            name: String(describing: BreedImagesViewController.self),
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: BreedImagesViewController.self)
        ) as! BreedImagesViewController
        
        breedImagesViewController.breedName = breeds![indexPath.row]
        
        navigationController?
            .pushViewController(breedImagesViewController, animated: true)
    }
}
