//
//  CoreDataService.swift
//  WorkWithData
//
//  Created by Гурген Хоршикян on 26.11.2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // Свойство которое позволяет работать с ManageObjec (удалять, сохранять, доставать все)
    lazy var context = appDelegate.persistentContainer.viewContext
    
    /// Обновляет существующую модель
    /// - Parameter name: ключевое слово по которому извлекается значение из базы данных
    func update(_ name: String, newName: String) {
        let request: NSFetchRequest<PersonCoreDataModel> = PersonCoreDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let models = try context.fetch(request)
            
            guard !models.isEmpty else { return }
            
            models[0].name = newName
            
            try context.save()
            print("\(name) update ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Возвращает все модели из базы данных
    /// - Returns: все модели
    func fetchName() -> [PersonCoreDataModel] {
        let request: NSFetchRequest<PersonCoreDataModel> = PersonCoreDataModel.fetchRequest()
        
        do {
            let models = try context.fetch(request)
            return models
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    /// Добавляет имя в базу данных
    /// - Parameter name: текст который записывается в базу данных 
    func addName(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "PersonCoreDataModel", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! PersonCoreDataModel
        
        taskObject.name = name
        
        do {
            try context.save()
            print("\(name) save ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Удаляет имя из базы данных
    /// - Parameter name: имя
    func deleteCity(_ name: String) {
        let fetchRequest: NSFetchRequest<PersonCoreDataModel> = PersonCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "location == %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return }
            
            context.delete(result[0])
            try context.save()
            print("\(name) delete ❌❌❌")
        } catch {
            print(error.localizedDescription)
        }
    }
}
