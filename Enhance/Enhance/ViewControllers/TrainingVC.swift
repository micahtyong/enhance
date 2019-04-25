//
//  TrainingVC.swift
//  
//
//  Created by Micah Yong on 4/17/19.
//

import UIKit
import Hero

class TrainingVC: UIViewController {
    
    var user : User = Enhance.user
    
    let customOrange = UIColor(red: 0.98, green: 0.65, blue: 0.01, alpha: 1)
    let customWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 120
    
    var tableView: UITableView = UITableView()
    var activityData = [Activity]()
    var currActivity: UIViewController = StepsVC()
    
    let lineup : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Enhance.user
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // UX
    
    
    // UI
    
    func setupUI() {
        self.view.backgroundColor = customWhite
        setupLine()
        setupActivities()
        setupTable()
    }
    
    func setupActivities() {
        activityData = [Activity.init(title: "Strength", image: UIImage.init(named: "dumbell"), description: "Let's do some pushups!", activity: PushupMLVC()),
                        Activity.init(title: "Stamina", image: UIImage.init(named: "thunder"), description: "How many steps in 10 minutes?", activity: StepsVC()),
                        Activity.init(title: "Core", image: UIImage.init(named: "pushupgirl"), description: "Let's work on form and abs!", activity: SitupMLVC())]
    }
    
    func setupLine() {
        lineup.frame = CGRect(x: 0, y: 0, width: 0, height: 739.01)
        lineup.backgroundColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1)
        
        self.view.addSubview(lineup)
        
        let trailingConstant = self.screenSize().size.width * 0.265 * -1
        
        lineup.translatesAutoresizingMaskIntoConstraints = false
        lineup.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        lineup.widthAnchor.constraint(equalToConstant: 1).isActive = true
        lineup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant).isActive = true
        lineup.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    }

}

extension TrainingVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
        tableView.backgroundColor = .clear
        tableView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: screenHeight - 20)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrainingCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.screenSize().size.height * 0.05 * -1).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -10).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.activityData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let heightConstant : CGFloat = 0.1477
        let cellSpacingHeight2: CGFloat = self.screenSize().size.height * heightConstant
        return cellSpacingHeight2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightConstant : CGFloat = 0.125
        let height: CGFloat = self.screenSize().size.height * heightConstant
        return height
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TrainingCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TrainingCell
        cell.setLabels(to: activityData[indexPath.section].title, and: activityData[indexPath.section].description)
        cell.trainButton.tag = indexPath.section
        cell.trainButton.addTarget(self, action: #selector(launchCoreML), for: .touchUpInside)
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath) as! TrainingCell
        let cells = self.tableView.visibleCells as! [TrainingCell]
        for cell in cells {
            if cell.isEqual(currentCell) {
                cell.igniteCore()
                currActivity = activityData[indexPath.section].activity
            } else {
                cell.extinguishCore()
            }
        }
        print("You tapped cell number \(indexPath.section).")
    }
    
    @objc func launchCoreML(_ sender : CoreButton) {
        let vc = currActivity
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .up), dismissing: .zoomOut)
        self.present(vc, animated: true, completion: nil)
    }
    
}
