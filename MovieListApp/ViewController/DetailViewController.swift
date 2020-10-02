//
//  DetailViewController.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import UIKit

class DetailViewController: UIViewController, DataLoading {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movieId: String?
    var movieTitle: String?
    var movieImage: UIImage?
    
    private var movieInfo: MovieInfo?
    private var comments: [Comment]?
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
        
        setupTableView()
        setupTableViewCell()
        
        //Networking
        getDataFromServer(safe(movieId))
        
        //test
        print(safe(movieId))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    fileprivate func setupTableViewCell() {
        let infoNib = UINib(nibName: InfoCell.reusableIdentifier, bundle: nil)
        tableView.register(infoNib, forCellReuseIdentifier: InfoCell.reusableIdentifier)
        let synopsisNib = UINib(nibName: SynopsisCell.reusableIdentifier, bundle: nil)
        tableView.register(synopsisNib, forCellReuseIdentifier: SynopsisCell.reusableIdentifier)
        let directorNib = UINib(nibName: DirectorInfoCell.reusableIdentifier, bundle: nil)
        tableView.register(directorNib, forCellReuseIdentifier: DirectorInfoCell.reusableIdentifier)
        let commentsNib = UINib(nibName: CommentsCell.reusableIdentifier, bundle: nil)
        tableView.register(commentsNib, forCellReuseIdentifier: CommentsCell.reusableIdentifier)
    }
    
    fileprivate func getDataFromServer(_ id: String) {
        let group = DispatchGroup()
        var check = true
        loadingState = .loading
        
        group.enter()
        getInfoDataFromServer(id, completion: { (isSuccess) in
            check = isSuccess && check
            group.leave()
        })
        
        group.enter()
        getCommentsDataFromServer(id, completion: { (isSuccess) in
            check = isSuccess && check
            group.leave()
        })
        
        group.notify(queue: .main) {
            switch check {
            case true:
                self.tableView.reloadData()
            case false:
                self.loadingState = .error(code: "Loading Fail")
            }
        }
        
    }
    fileprivate func getInfoDataFromServer(_ id: String, completion: @escaping (_ isSuccess: Bool) -> ()){
       APImanager.getMovieDetail(id) { (movieInfo, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                self.movieInfo = movieInfo
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    fileprivate func getCommentsDataFromServer(_ id: String, completion: @escaping (_ isSuccess: Bool) -> ()){
        APImanager.getComments(id) { (comments, code) in
            let result = self.response.result(code)
            switch result{
            case .success:
                self.comments = comments
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    
}


extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "줄거리"
        case 2: return "감독 / 출연"
        case 3: return "한줄평"
        default: return ""
        }
    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            if let count = comments?.count {
                return count
            }
            return 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return setupInfoCell(indexPath)
        case 1: return setupSynopsisCell(indexPath)
        case 2: return setupDirectorInfoCell(indexPath)
        case 3: return setupCommentsCell(indexPath)
        default: return UITableViewCell()
        }
    }
    
    
    
    func setupInfoCell( _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.reusableIdentifier, for: indexPath) as? InfoCell else { return UITableViewCell() }
        cell.movieTitleLabel.text = movieTitle
        cell.movieImageView.image = movieImage
        cell.movieInfoLabel.text = safe(movieInfo?.date) + "개봉"
        cell.movieSubInfoLabel.text = safe(movieInfo?.genre)
        cell.reservationLateLabel.text =  "\(safe(movieInfo?.reservationGrade))위/\(safe(movieInfo?.reservationRate))"
        cell.audienceLabel.text = safe(movieInfo?.audience)
        cell.rateLabel.text = safe(movieInfo?.userRating)
        
        return cell
    }
    
    func setupSynopsisCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisCell.reusableIdentifier, for: indexPath) as? SynopsisCell else { return UITableViewCell() }
        cell.synopsisLabel.text = movieInfo?.synopsis
        return cell
    }
    
    func setupDirectorInfoCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectorInfoCell.reusableIdentifier, for: indexPath) as? DirectorInfoCell else { return UITableViewCell() }
        
        cell.directorLabel.text = movieInfo?.director
        cell.actorLabel.text = movieInfo?.actor
        return cell
    }
    
    func setupCommentsCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.reusableIdentifier, for: indexPath) as? CommentsCell else { return UITableViewCell() }
        
        let data = comments?[indexPath.row]
        cell.userName.text = data?.writer
        cell.dateLabel.text = safe(data?.timeStamp)
        cell.commentLabel.text = data?.contents
        
        return cell
    }
    
}


extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
}
