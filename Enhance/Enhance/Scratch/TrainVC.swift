//
//  TrainVC.swift
//  Enhance
//
//  Created by Micah Yong on 4/13/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit
import Hero

class TrainVC: UIViewController {
    
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var scrollViewData = [scrollViewDataStruct]()
    var scrollView: UIScrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = customOrange
        setupStruct()
        setupScrollView()
        setupCells()
    }
    
    func setupCells() {
        var i = 0
        for data in scrollViewData {
            let view = CustomView(frame: CGRect(x: 10 + (self.scrollView.frame.width * CGFloat(i)), y: 80, width: self.scrollView.frame.width - 20, height: self.scrollView.frame.height))
            view.imageView.image = data.image
            self.scrollView.addSubview(view)
            
            let label = UILabel(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 20), size: CGSize.init(width: 0, height: 40)))
            label.backgroundColor = .white
            label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            label.font = UIFont(name: "AvenirNext-Regular", size: 30)
            label.text = data.title
            label.center.x = view.center.x
            label.sizeToFit()
            label.textAlignment = .left
            if i == 0 {
                label.center.x = view.center.x
            } else {
                label.center.x = view.center.x + CGFloat(i) * self.scrollView.frame.width
            }
            self.scrollView.addSubview(label)
            i += 1
        }
    }

    func setupStruct() {
        scrollViewData = [scrollViewDataStruct.init(title: "Strength", image: UIImage.init(named: "dumbell")),
                          scrollViewDataStruct.init(title: "Stamina", image: UIImage.init(named: "thunder")),
                          scrollViewDataStruct.init(title: "Core", image: UIImage.init(named: "pushupgirl"))]
    }
    
    func setupScrollView() {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(scrollViewData.count)
        scrollView.backgroundColor = customOrange
        
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
    }

}
