//
//  safe .swift
//  MovieListApp
//
//  Created by 권민재 on 2020/10/02.
//

import UIKit

extension UIViewController {
    
    
    func safe(_ data: String?) -> String {
        guard let unlock = data else { return ""}
        return unlock
    }

    func safe(_ data: Double?) -> String {
        guard let unlock = data else { return "" }
        return String(unlock)
    }

    func safe(_ data: Int?) -> String {
        guard let unlock = data else { return "" }
        return String(unlock)
    }
}

