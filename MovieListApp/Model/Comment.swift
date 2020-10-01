//
//  Comment.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/10/01.
//

import Foundation


struct Comments: Codable {
    
    let movieId: String?
    let comments: [Comment]?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case comments, message
        case movieId = "movie_id"
    }
}



struct Comment: Codable {
    
    let rating: Double?
    let timeStamp: Double?
    let writer: String?
    let movieID: String?
    let contents: String?
    
    private enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case timeStamp = "timestamp"
        case movieID = "movie_id"
    }
    
    
}
