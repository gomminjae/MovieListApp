//
//  MovieInfo.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import Foundation


struct MovieInfo: Codable {
    
    let audience: Int?
    let actor: String?
    let duration: Int?
    let director: String?
    let synopsis: String?
    let genre: String?
    let grade: Int?
    let image: String?
    let reservationGrade: Int?
    let title: String?
    let reservationRate: Double?
    let userRating: Double?
    let date: String?
    let id: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id, message
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
