//
//  PhotoDisplayVC.swift
//  Enhance
//
//  Created by Micah Yong on 5/2/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class PhotoDisplayVC: UIViewController {
    
    let imageView : UIImageView = UIImageView()
    var takenPhoto : UIImage = UIImage(named: "pushupDemo")!
    
    let backButton : BackButton = BackButton()
    let saveButton : CustomMedButton = CustomMedButton(withText: "Save photo", withInverted: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        setupImageView()
        setupBackButton()
        setupSaveButton()
    }
    
    @objc func save(_ sender : CustomMedButton) {
        sender.pulse()
        UIImageWriteToSavedPhotosAlbum(takenPhoto, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        self.view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
    }
    
    func setImageTo(_ image: UIImage) {
        takenPhoto = image
        imageView.image = takenPhoto
    }
    
    func setBackgroundTo(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    
    func setupImageView() {
        imageView.backgroundColor = .clear
        imageView.image = takenPhoto
        imageView.contentMode = .center
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    func setupBackButton() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func goBack(_ sender:UIButton) {
        sender.pulse()
        dismiss(animated: true, completion: nil)
    }

}
