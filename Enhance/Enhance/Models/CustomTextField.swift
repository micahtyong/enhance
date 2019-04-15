//
//  CustomTextField.swift
//  Enhance
//
//  Created by Micah Yong on 4/13/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class CustomTextField: UIView {
    
    var placeHolder: String = "Enter text"
    var textField = UITextField()
    let blackBar = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setPlaceHolder(holder : String) {
        placeHolder = holder
        textField.placeholder = placeHolder
    }
    
    func setupUI() {
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        setupTextField()
        setupBlackBar()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupTextField() {
        textField.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        textField.backgroundColor = .white
        textField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        textField.font = UIFont(name: "AvenirNext-Regular", size: 20)
        textField.textAlignment = .center
        
        textField.placeholder = placeHolder
//        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.keyboardAppearance = UIKeyboardAppearance.dark
        textField.returnKeyType = UIReturnKeyType.done
//        textField.clearButtonMode = UITextField.ViewMode.always
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        self.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    func setupBlackBar() {
        blackBar.frame = CGRect(x: 0, y: 0, width: 300, height: 10)
        blackBar.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        self.addSubview(blackBar)
        
        blackBar.translatesAutoresizingMaskIntoConstraints = false
        blackBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        blackBar.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        blackBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        blackBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }

}
