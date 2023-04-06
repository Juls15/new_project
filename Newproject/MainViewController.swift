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
    
    var tasks: [Task] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.networkItem.getSession{ items in
            self.tasks = items
        }
        
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.backgroundColor = .white
        
        setUpMenuButton()
    }
    
    func setUpMenuButton(){
        let menuBtn = UIButton()
        let img = UIImage(named:"plus.png")
        menuBtn.setImage(img, for: .normal)
        menuBtn.addTarget(self, action: #selector(tapButton), for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    @objc func tapButton() {
        let vc = ItemViewController(delegate: self)
        self.navigationController?.present(vc, animated: true)
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
