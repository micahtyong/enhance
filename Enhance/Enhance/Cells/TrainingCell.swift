//
//  TrainingCell.swift
//  Enhance
//
//  Created by Micah Yong on 4/15/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import Foundation
import UIKit

class TrainingCell: UITableViewCell {
    
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    var headerText : String = "Strength"
    var descriptionText : String = "Let's do some pushups!"
    
    let cellView: UIView = UIView()
    
    let headerView: UIView = UIView()
    let header: UILabel = UILabel()
    let subHeader: UILabel = UILabel()
    
    let trainButton: CoreButton = CoreButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Cell created")
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func igniteCore() {
        trainButton.igniteButton()
    }
    
    func extinguishCore() {
        trainButton.extinguishButton()
    }
    
    func setLabels(to text: String, and description: String) {
        headerText = text
        header.text = headerText
        descriptionText = description
        subHeader.text = descriptionText
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        let logoFactor : CGFloat = 0.13
        let screenHeight = self.screen().size.height
        let logoConstant = logoFactor * screenHeight
        self.frame = CGRect(x: 0, y: 0, width: self.screenSize().size.width, height: logoConstant)
        self.heightAnchor.constraint(equalToConstant: logoConstant).isActive = true
        setupCellView()
        setupButton()
        setupLabels()
        
    }
    
    func setupCellView() {
        cellView.backgroundColor = .clear
        
        self.addSubview(cellView)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func setupButton() {
        cellView.addSubview(trainButton)
        
        trainButton.translatesAutoresizingMaskIntoConstraints = false
        trainButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -50).isActive = true
        trainButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        trainButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0).isActive = true
    }
    
    func setupLabels() {
        headerView.backgroundColor = .clear
        headerView.frame = CGRect(x: 0, y: 0, width: 195, height: 72)
        setupHeader()
        setupDescription()
        cellView.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 50).isActive = true
        headerView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0).isActive = true
//        cellView.frame.size.height * 0.1
        headerView.trailingAnchor.constraint(equalTo: trainButton.leadingAnchor, constant: 0).isActive = true
        headerView.heightAnchor.constraint(equalTo: cellView.heightAnchor, multiplier: 0.6, constant: 0).isActive = true
    }
    
    func setupDescription() {
        subHeader.backgroundColor = .clear
        subHeader.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        subHeader.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        subHeader.minimumScaleFactor = 0.5
        subHeader.adjustsFontSizeToFitWidth = true
        subHeader.numberOfLines = 0
        subHeader.text = descriptionText
        
        headerView.addSubview(subHeader)
        
        subHeader.translatesAutoresizingMaskIntoConstraints = false
        subHeader.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        subHeader.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0).isActive = true
        subHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
        subHeader.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.30).isActive = true
    }
    
    func setupHeader() {
        header.backgroundColor = .clear
        header.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        header.font = UIFont(name: "AvenirNext-Regular", size: 30)
        header.text = headerText
        header.minimumScaleFactor = 0.5
        header.adjustsFontSizeToFitWidth = true
        header.textAlignment = .left
        
        headerView.addSubview(header)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0).isActive = true
        header.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        header.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.70).isActive = true
    }
    
    func screen() -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return screenSize
    }
    
}
