//
//  CustomTableViewCell.swift
//  Newproject
//
//  Created by Yulya on 24.03.2023.
//

import Foundation
import UIKit

protocol MainVCProtocol: AnyObject {
    func getNavigation() -> UINavigationController?
    func setTask(task: Task)
    func deleteTask(index: Int)
    func editTask(index: Int, task: Task)
}

class CustomTableViewCell: UITableViewCell {
    
    var delegate: MainVCProtocol?
    
    var task: Task?
    var collection: MainViewController!
    var index: Int?
    
    let button1 = UIButton()
    let button2 = UIButton()
    let label = UILabel()
    let view = UIView()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayoutOfLabel()
        setUpLayuotOfButton()
        setUpLayoutOfView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpLayoutOfLabel() {
        self.view.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
    }
    
    ///hui///
    
    func setUpLayoutOfView() {
        self.contentView.addSubview(view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    
    func setUpLayuotOfButton() {
        self.view.addSubview(self.button1)
        self.button1.translatesAutoresizingMaskIntoConstraints = false
        self.button1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        self.button1.leftAnchor.constraint(equalTo: self.label.rightAnchor, constant: 12).isActive = true
        self.button1.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        self.button1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.button1.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.button1.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        self.button1.tintColor = .systemGreen
        self.button1.addTarget(self, action: #selector(editButtonOn), for: .touchUpInside)
        
        self.view.addSubview(self.button2)
        self.button2.translatesAutoresizingMaskIntoConstraints = false
        self.button2.topAnchor.constraint(equalTo: self.button1.bottomAnchor, constant: 12).isActive = true
        self.button2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12).isActive = true
        self.button2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        self.button2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.button2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.button2.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        self.button2.tintColor = .systemRed
        self.button2.addTarget(self, action: #selector(deleteButtonOn), for: .touchUpInside)
    }
    
    
    func setupData(task: Task, index: Int) {
        self.index = index
        self.task = task
        self.label.text = task.name
//        if task.status! == true {
//            self.view.backgroundColor = .green
//        } else {
//            self.view.backgroundColor = .white
//        }
        self.label.text = task.name
    }

    
    @objc func editButtonOn() {
        let vc = ItemViewController(task: self.task, delegate: self.delegate, index: self.index)
        guard let nc = self.delegate?.getNavigation() else { return }
        nc.present(vc, animated: true)
    }
    
    
    @objc private func deleteButtonOn() {
        guard let id = self.task?.id else { return }
        NetworkManager.networkItem.deleteSession(param: ["id": id])
        self.delegate?.deleteTask(index: self.index!)
        
    }
}

