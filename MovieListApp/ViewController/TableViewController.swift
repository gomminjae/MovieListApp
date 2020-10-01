//
//  TableViewController.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import UIKit

class TableViewController: UIViewController, DataLoading {
    
    
    private var movies: [Movie] = []
    private var posters: [UIImage]?
    private var APImanager = APIManager()
    private var response = CallbackResponse()
    var orderType: Int = 0 {
        didSet {
            getMoviesFromServer(orderType)
        }
    }
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
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
                tableView.reloadData()
            case .refreshed:
                stateChanged(view)
                tableView.reloadData()
            case .error:
                stateChanged(view)
            }
        }
    }
    
    @IBOutlet weak var orderTypeButton: UIButton!
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        orderTypeButton.addTarget(self, action: #selector(orderTypeButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        getMoviesFromServer(orderType)

        // Do any additional setup after loading the view.
    }
    
    
    private func setupTableView(){
        let nibName = UINib(nibName: TableViewCell.reusableIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: TableViewCell.reusableIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
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
                    self.tableView.reloadData()
                }
                DispatchQueue.global(qos: .background).async {
                    self.posters = self.downloadImages(movies)
                    DispatchQueue.main.async {
                        self.loadingState = .loaded
                    }
                }
            case .failure:
                print("error")
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
                    self.tableView.reloadData()
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
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reusableIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let data = movies[indexPath.row]
        
        cell.movieTitle.text = data.title
        if let poster = posters?[indexPath.item] {
            cell.movieImageView.image = poster
        }
        cell.dateLabel.text = data.date
        cell.infoLabel.text = "평점: \(data.userRating!) 예매순위: \(data.reservationGrade!) 예매율: \(data.reservationRate!)"
        return cell
    }
    
    
}
extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
