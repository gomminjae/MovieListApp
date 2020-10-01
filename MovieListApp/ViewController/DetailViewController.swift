//
//  DetailViewController.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import UIKit

class DetailViewController: UIViewController, DataLoading {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    var movieId: String?
    var movieInfo: MovieInfo?
    var movieImage: UIImage?
    private var APImanager = APIManager()
    private var response = CallbackResponse()
    
    var indicatorView: IndicatorView = {
        let view = IndicatorView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        return view
    }()
    
    var loadingState: LoadingState = .loading {
        didSet {
            switch loadingState {
            case .loading:
                stateChanged(view)
            case .loaded:
                stateChanged(view)
            case .refreshed:
                break
            case .error:
                stateChanged(view)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(movieId!)
        
        movieImageView.image = movieImage
        
        if let id = movieId {
            getDetail(safe(id))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    
    
    func safe(_ data: String?) -> String {
        guard let unlock = data else { return ""}
        return unlock
    }
    
    fileprivate func getDetail(_ id: String) {
        APImanager.getMovieDetail(id) { (movieInfo, code) in
            let result = self.response.result(code)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.movieInfo = movieInfo
                }
            case .failure:
                print("error")
            }
        }
    }
    

   

}
