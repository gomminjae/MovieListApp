//
//  LoadingState.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/10/01.
//

import UIKit


enum LoadingState {
    case loading
    case loaded
    case refreshed
    case error(code: String)
}

protocol DataLoading {
    
    var indicatorView: IndicatorView { get }
    var refreshControl: UIRefreshControl { get }
    var loadingState: LoadingState { get set }
    
    func stateChanged(_ view: UIView)
}


extension DataLoading where Self: UIViewController {
    
    var refreshControl: UIRefreshControl {
        get { return UIRefreshControl() }
    }
    
    func stateChanged(_ view: UIView) {
        switch loadingState {
        case .loading:
            indicatorView.center = view.center
            indicatorView.indicator.startAnimating()
            view.addSubview(indicatorView)
        case .loaded:
            indicatorView.indicator.stopAnimating()
            indicatorView.removeFromSuperview()
        case .refreshed:
            refreshControl.endRefreshing()
        case .error(let code):
            DispatchQueue.main.async {
                let errorAlert = UIAlertController(title: "오류", message: code, preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
