//
//  CallbackResult.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import Foundation


enum CallbackResult {
    case success
    case failure
}

struct CallbackResponse {
    func result(_ code: String?) -> CallbackResult {
        switch code {
        case "success": return .success
        default: return .failure
        }
    }
}
