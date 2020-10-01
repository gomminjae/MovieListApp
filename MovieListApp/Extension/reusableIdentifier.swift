//
//  reusableIdentifier.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import Foundation


extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
