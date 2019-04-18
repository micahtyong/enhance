//
//  CustomView.swift
//  Enhance
//
//  Created by Micah Yong on 4/17/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation
import UIKit

class CustomView: UIView {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupImageView()
    }
    
    func setupImageView() {
        self.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
}
