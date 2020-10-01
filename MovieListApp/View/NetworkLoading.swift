//
//  NetworkLoading.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/10/01.
//

import Foundation

enum LoadingState {
    case loading
    case loaded
    case erorr
    case refresh
}

protocol DataLoading {
    var loadingView: LoadingView
}
