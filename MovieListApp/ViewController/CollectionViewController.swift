//
//  CollectionViewController.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import UIKit

class CollectionViewController: UIViewController, DataLoading {
    
    @IBOutlet weak var orderTypeButton: UIButton!
    
    private var movies: [Movie] = []
    private var posters: [UIImage]?
    private var APImanager = APIManager()
    private var response = CallbackResponse()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var orderType: Int = 0 {
        didSet {
            getMoviesFromServer(orderType)
        }
    }
    
    var indicatorView: IndicatorView = {
        let view = IndicatorView()
        return view
    }()
    
    var loadingState: LoadingState = .loading {
        didSet {
            switch loadingState {
            case .loading:
                stateChanged(view)
            case .loaded:
                stateChanged(view)
                collectionView.reloadData()
            case .refreshed:
                stateChanged(view)
                collectionView.reloadData()
            case .error:
                stateChanged(view)
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        collectionViewLayout()
        
        orderTypeButton.addTarget(self, action: #selector(orderTypeButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        
        getMoviesFromServer(orderType)

        
    }
    
    
    private func setupCollectionView() {
        let nibName = UINib(nibName: CollectionViewCell.reusableIdentifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: CollectionViewCell.reusableIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func collectionViewLayout() {
        let spacing: CGFloat = 16.0
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let vc = segue.destination as? DetailViewController else { return }
            
            if let index = sender as? Int {
                vc.movieId = movies[index].id
                vc.movieImage = posters?[index]
            }
            
        }
    }
    
    
    @objc func orderTypeButtonTapped() {
        let alert = UIAlertController(title: "select orderType", message: "Choose", preferredStyle: .actionSheet)
        
        let orderType1 = UIAlertAction(title: "예매율", style: .default) { action in
            self.getMoviesFromServer(0)
            
        }
        let orderType2 = UIAlertAction(title: "큐레이션", style: .default) { action in
            self.getMoviesFromServer(1)
            
        }
        let orderType3 = UIAlertAction(title: "개봉일", style: .default) { action in
            self.getMoviesFromServer(2)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(orderType1)
        alert.addAction(orderType2)
        alert.addAction(orderType3)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func safe(_ data: String?) -> String {
        guard let unlock = data else { return ""}
        return unlock
    }
    fileprivate func getMoviesFromServer(_ orderType: Int) {
        APImanager.getMovies(orderType) { (movies, code) in
            let result = self.response.result(code)
            switch result {
            case .success:
                
                //main thread
                DispatchQueue.main.async {
                    self.movies = movies ?? []
                    self.collectionView.reloadData()
                    //self.posters = self.downloadImages(movies)
                }
                //background
                DispatchQueue.global(qos: .background).async {
                    self.posters = self.downloadImages(movies)
                    DispatchQueue.main.async {
                        self.loadingState = .loaded
                    }
                }
            case .failure:
                self.loadingState = .error(code: code)
            }
        }
    }
    fileprivate func downloadImage(url: String) -> UIImage? {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)
            }
        }
        return UIImage()
    }
    
    
    fileprivate func downloadImages(_ movies: [Movie]?) -> [UIImage] {
        var imageArr: [UIImage] = []
        guard let movies = movies else {
            return imageArr
        }
        for movie in movies {
            if let image = self.downloadImage(url: self.safe(movie.thumb)) {
                imageArr.append(image)
            }
        }
        return imageArr
    }
    
    @objc func refreshData() {
        APImanager.getMovies(orderType) { (movies, code) in
            let result = self.response.result(code)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.movies = movies ?? []
                    self.collectionView.reloadData()
                }
                DispatchQueue.global(qos: .background).async {
                    self.posters = self.downloadImages(movies)
                    DispatchQueue.main.async {
                        self.loadingState = .loaded
                    }
                }
                
            case .failure:
                self.loadingState = .error(code: code)
            }
        }
    }
}


extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reusableIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.movieTitle.text = movies[indexPath.item].title
        if let poster = posters?[indexPath.item] {
            cell.movieImageView.image = poster
        }
        return cell
    }
    
    
}


extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
    
}



extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItem = 2
        let spacing = 16
        
        let totalSpacing = (2 * 16) + ((numberOfItem - 1) * spacing)
        let cellSize = (Int((collectionView.bounds.width)) - totalSpacing) / numberOfItem
        return CGSize(width: cellSize, height: cellSize)
    }
    
}
