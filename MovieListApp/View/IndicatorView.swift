//
//  IndicatorView.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/10/01.
//

import UIKit


class IndicatorView: UIView {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed(IndicatorView.reusableIdentifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.center = self.center
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        self.addSubview(view)
    }
}
