//
//  ItemViewController.swift
//  Newproject
//
//  Created by Yulya on 23.03.2023.
//

import Foundation
import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: MainVCProtocol?
    
    let textFieldSaved = UITextField()
    let saveButton = UIButton()
    let textFieldComments = UITextField()
    let switchButton = UISwitch()
    let savedPickerView = UIPickerView()
    
    var task: Task?
    var category: [Category] = [.family,.work,.friends,.health,.hobby,.holidays,.home]
    var changedCategory: Category?
    var savedTask: String = ""
    var savedComments: String = ""
    var pVC: MainViewController?
    var index: Int?
    
    
    init(task: Task? = nil, delegate: MainVCProtocol? = nil, index: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        if task != nil {
            self.task = task
        }
        self.index = index
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLayoutOfTextField()
        setUpLayoutOfPickerView()
        setUpLayoutOfButton()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func setUp() {
        self.pVC = MainViewController()
        textFieldComments.delegate = self
        textFieldSaved.delegate = self
        textFieldSaved.text = task?.name
        textFieldComments.text = task?.description
        self.savedPickerView.delegate = self
        self.savedPickerView.dataSource = self
        
        view.backgroundColor = .white
        
        var index: Int = 0
        var savedIndex: Int = 0
        for category in self.category {
            let type = self.fromTypeToCat(type: task?.type ?? 0)
            if type == category {
                savedIndex = index
            }
            index += 1
        }
        self.changedCategory = self.category[savedIndex]
        savedPickerView.selectRow(savedIndex, inComponent: 0, animated: false)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.changedCategory = category[row]
        print(category[row])
    }
    
    
    func setUpLayoutOfTextField() {
        self.view.addSubview(self.textFieldSaved)
        self.textFieldSaved.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldSaved.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        self.textFieldSaved.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.textFieldSaved.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.textFieldSaved.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.textFieldSaved.layer.cornerRadius = 20
        self.textFieldSaved.backgroundColor = .systemMint
        
        self.view.addSubview(self.textFieldComments)
        self.textFieldComments.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldComments.topAnchor.constraint(equalTo: self.textFieldSaved.bottomAnchor, constant: 20).isActive = true
        self.textFieldComments.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.textFieldComments.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.textFieldComments.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.textFieldComments.layer.cornerRadius = 20
        self.textFieldComments.backgroundColor = .systemMint
    }
    
    
    func setUpLayoutOfPickerView() {
        self.view.addSubview(self.savedPickerView)
        self.savedPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.savedPickerView.topAnchor.constraint(equalTo: self.textFieldComments.bottomAnchor, constant: 20).isActive = true
        self.savedPickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.savedPickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.savedPickerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.savedPickerView.backgroundColor = .white
    }
    
    
    func setUpLayoutOfButton() {
        self.saveButton.addTarget(self, action: #selector(saveButtonOn), for: .touchUpInside)
        self.view.addSubview(self.saveButton)
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.topAnchor.constraint(equalTo: self.savedPickerView.bottomAnchor, constant: 20).isActive = true
        self.saveButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        self.saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        self.saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.saveButton.layer.cornerRadius = 20
        self.saveButton.backgroundColor = .systemMint
        self.saveButton.setTitle("OK", for: .normal)
    }
    
    
    func fromCatToType(category: Category) -> Int {
        switch category {
        case .home: return 1
        case .work: return 2
        case .hobby: return 3
        case .family: return 4
        case .friends: return 5
        case .holidays: return 6
        case .health: return 7
        default: return 1
        }
    }
    
    
    func fromTypeToCat(type: Int) -> Category {
        switch type {
        case 1: return .home
        case 2: return .work
        case 3: return .hobby
        case 4: return .family
        case 5: return .friends
        case 6: return .holidays
        case 7: return .health
        default: return .home
        }
    }
    
    
    private func createNewTask() {
        let savedTaskName = String(textFieldSaved.text!)
        print("savedTask = \(savedTaskName)")
        let savedTaskComment = String(textFieldComments.text!)
        print ("savedComments = \(savedTaskComment)")
        var type = 1
        if let changedCategory {
            type = self.fromCatToType(category: changedCategory)
        }
        let savedTask = Task(id: nil, name: savedTaskName, description: savedTaskComment, status: true, type: type)
        self.addNewTaskToArray(savedTask: savedTask)
        self.dismiss(animated: true)
    }
    
    
    private func addNewTaskToArray(savedTask: Task) {
        let param  = ["name": savedTask.name!, "description": savedTask.description!, "type": savedTask.type!] as [String : Any]
        NetworkManager.networkItem.addSession(param: param) { task in
            self.delegate?.setTask(task: task)
        }
    }
    
    
    private func editTask(savedTask: Task) {
        self.editTaskInArray(savedTask: savedTask)
        self.dismiss(animated: true)
    }
    
    
    private func editTaskInArray(savedTask: Task) {
        
        var params: [String: Any] = [:]

        if textFieldSaved.text != self.task?.name  {
            params["name"] = String(textFieldSaved.text!)
        }
        if textFieldComments.text != self.task?.description {
            params["descritpion"] = textFieldComments.text
        }
        if fromCatToType(category: changedCategory!) != self.task?.type{
            params["type"] = fromCatToType(category: changedCategory!)
        }
        if params.isEmpty == false {
            params["id"] = self.task?.id
            NetworkManager.networkItem.updateSession(param: params) { task in
                self.delegate?.editTask(index: self.index!, task: task)
            }
        }
//        guard let id = self.task?.id else { return }
//        if String(textFieldSaved.text!) == self.task?.name || String(textFieldComments.text!) == self.task?.description {
//            let param  = ["id": id, "name": savedTask.name!, "description": savedTask.description!, "type": savedTask.type!] as! [String : Any]
//            NetworkManager.networkItem.updateSession(param: param) { task in
//                self.delegate?.editTask(index: self.index!, task: task)
//            }
//        } else {
//            return
//        }
    }
    
    
    @objc func saveButtonOn() {
        if self.index != nil {
            let savedTask = Task(id: self.task?.id,  name: String(textFieldSaved.text ?? ""), description: String(textFieldComments.text ?? ""), status: true, type: fromCatToType(category: self.changedCategory ?? .home))
                self.editTask(savedTask: savedTask)
        } else {
                self.createNewTask()
        }
    }
}

