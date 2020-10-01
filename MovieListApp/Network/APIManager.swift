//
//  APIManager.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import Foundation


class APIManager {
    
    let apiService = APIService<boxOfficeAPI>()
    
    func getMovies(_ orderType: Int, completion: @escaping (_ resultData: [Movie]?, _ code: String) -> (Void)) {
        
        apiService.request(.movies(order_type: orderType)) { (data, response, code) in
            guard let responseData = data else {
                completion(nil, code)
                return
            }
            do {
                let decodeJSON = try JSONDecoder().decode(Movies.self, from: responseData)
                if let code = decodeJSON.message{
                    completion(nil, code)
                } else{
                    completion(decodeJSON.movies, code)
                }
            }catch{
                completion(nil, code)
            }
        }
    }
    func getMovieDetail(_ id: String, completion: @escaping (_ movieInfo: MovieInfo?, _ code: String) -> (Void)) {
        apiService.request(.movie(id: id)) { (data, response, code) in
            guard let responseData = data else {
                completion(nil, code)
                return
            }
            do {
                let decodeJSON = try JSONDecoder().decode(MovieInfo.self, from: responseData)
                if let message = decodeJSON.message{
                    completion(nil, message)
                } else{
                    completion(decodeJSON, code)
                }
            }catch{
                completion(nil, code)
            }
        }
    }
    
    ////Todo getComment() 구현
    func getComments(_ id: String, completion: @escaping (_ comments: [Comment]?, _ code: String) -> (Void)) {
        apiService.request(.comments(id: id)) { (data, response, code) in
            guard let responseData = data else {
                completion(nil, code)
                return
            }
            do {
                let decodeJson = try JSONDecoder().decode(Comments.self, from: responseData)
                if let message = decodeJson.message {
                    completion(nil, message)
                }else {
                    completion(decodeJson.comments, code)
                }
            }catch {
                completion(nil, code)
            }
        }
    }
}
