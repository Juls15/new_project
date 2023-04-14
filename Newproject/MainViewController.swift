//
//  MainViewController.swift
//  Newproject
//
//  Created by Yulya on 23.03.2023.
//

import Foundation
import UIKit


class MainViewController: UIViewController {
    
    var tableView = UITableView()
    let logoutButton = UIButton()
    
    var tasks: [Task] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.networkItem.setGetTokenFromUserDefaults()
        NetworkManager.networkItem.getSession{ data in
            if let result = data.result {
                self.tasks = result
            } else if let error = data.error {
                print(error)
            }
        }
        
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        
        setUpMenuButton()
        setUpLogoutButton()
    }

    
    func setUpMenuButton() {
        let menuBtn = UIButton()
        let img = UIImage(named:"plus.png")
        menuBtn.setImage(img, for: .normal)
        menuBtn.addTarget(self, action: #selector(addButtonOn), for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    
    func setUpLogoutButton() {
        self.logoutButton.backgroundColor = .systemMint
        self.logoutButton.addTarget(self, action: #selector(logoutButtonOn), for: .touchUpInside)
        self.logoutButton.setTitle("Logout", for: .normal)
        self.logoutButton.layer.cornerRadius = 10
        
        let menuBarItem = UIBarButtonItem(customView: logoutButton)
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    @objc func addButtonOn() {
        let vc = ItemViewController(delegate: self)
        self.navigationController?.present(vc, animated: true)
    }
    
    
    @objc func logoutButtonOn() {
        UserDefaults.standard.removeObject(forKey: "token")
        let sd = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let authVC = ViewController()
        sd?.setRootNC(rootVC: authVC)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.setupData(task: self.tasks[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
}


extension MainViewController: MainVCProtocol {

    func getNavigation() -> UINavigationController? {
        guard let nc = self.navigationController else { return nil}
        return nc
    }
    
    func setTask(task: Task) {
        self.tasks.append(task)
    }
    
    func editTask(index: Int, task: Task) {
        self.tasks[index] = task
    }
    
    func deleteTask(index: Int) {
        self.tasks.remove(at: index)
    }
     
}
