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


extension NameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.nameList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        guard let person = presenter?.nameList[indexPath.row] else { return UITableViewCell() }
        cell.textLabel!.text = person.name
        
        return cell
    }
}

