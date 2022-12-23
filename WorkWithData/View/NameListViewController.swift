//
//  ViewController.swift
//  WorkWithData
//
//  Created by Гурген Хоршикян on 25.11.2022.
//

import UIKit

protocol NameListViewProtocol: AnyObject {
    func reloadData()
}

class NameListViewController: UIViewController, NameListViewProtocol {
    var presenter: NameListPresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        presenter?.loadData()
    }

    @IBAction func addNameAction(_ sender: Any) {
        let alert = UIAlertController(title: "New name", message: "Add new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction!) -> Void in
            
            let textField = alert.textFields![0]
            guard let text = textField.text else { return }
            self.presenter?.appendName(text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Обновить значение в таблице 
    func reloadData() {
        tableView.reloadData()
    }
}


extension NameListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.nameList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        guard let person = presenter?.nameList[indexPath.row] else { return UITableViewCell() }
        cell.textLabel!.text = person.name
        cell.selectionStyle = .none
        
        return cell
    }
    
    /// Добавляет к нашим ячейкам свайпы, в которых находятся функции
    /// - Parameters:
    ///   - tableView: наша таблица
    ///   - indexPath: индекс по которому мы выбираем нашу ячейку
    /// - Returns: возвращает кнопки, которые мы реализовываем
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let changeElement = UIContextualAction(style: .normal, title: "Изменить") { (action, view, succes) in
            let alert = UIAlertController(title: "Update name", message: "Put new name", preferredStyle: .alert)
            let changeAction = UIAlertAction(title: "Change", style: .default) { [self] (Action: UIAlertAction!) in
                let textField = alert.textFields![0]
                guard let newName = textField.text else { return }
                guard let oldName = presenter?.nameList[indexPath.row].name else { return }
                self.presenter?.updateName(oldName: oldName, newName: newName)
                print("Update \(newName)")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(changeAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        let deleteElement = UIContextualAction(style: .normal, title: "Удалить") { [self] action, view, succes in
            guard let model = presenter?.nameList[indexPath.row].name else { return }
            presenter?.deleteName(at: model)
            print("Deleted \(model)")
        }
        changeElement.backgroundColor = .blue
        deleteElement.backgroundColor = .red
        
        return  UISwipeActionsConfiguration(actions: [deleteElement, changeElement])
    }
}

