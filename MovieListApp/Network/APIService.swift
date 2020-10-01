//
//  APIService.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import Foundation


protocol apiCompose {
    var baseUrl: URL { get }
    var subUrl: String { get }
}

enum boxOfficeAPI {
    case movies(order_type: Int)
    case movie(id: String)
    case comments(id: String)
}

extension boxOfficeAPI: apiCompose {
   var baseUrl: URL {
          guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/") else { fatalError("Invalid URL") }
          return url
      }
    var subUrl: String {
        switch self {
        case .movies(let order_type):
            return "movies?order_type=\(order_type)"
        case .movie(let id):
            return "movie?id=\(id)"
        case .comments(id: let id):
            return "comments?movie_id=\(id)"
        }
    }
}

class APIService<Service: apiCompose> {
    let statusCode = StatusCodeResponse()
    
    func request(_ server: Service, completion: @escaping (_ data: Data?,_ response: URLResponse?, _ code: String) -> ()) {
        guard let url = URL(string: server.baseUrl.absoluteString + server.subUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil,nil,"Internet Connection Fail")
                return
            }
            guard let data = data else {
                completion(nil, nil, "Data Receive Fail")
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.statusCode.result(response)
                switch result {
                case .success:
                    completion(data, response, "success")
                case .failure:
                    completion(nil, nil, "404 Error")
                case .badRequest:
                    completion(nil, nil, "Bad Request")
                case .serverError:
                    completion(nil, nil, "Server Error")
                }
            }
        }
        task.resume()
    }
}
