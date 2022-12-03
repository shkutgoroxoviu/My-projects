//
//  MainViewControllerPresenter.swift
//  WorkWithData
//
//  Created by Гурген Хоршикян on 29.11.2022.
//

import Foundation
import CoreData

protocol NameListPresenterProtocol {
   var nameList: [PersonCoreDataModel] { get }
    func appendName(_ name: String)
    func loadData()
    /// Функция удаления имени
    /// - Parameter name: имя, который надо удалить
    func deleteName(at name: String)
}

class NameListPresenter: NameListPresenterProtocol {
    weak var view: NameListViewProtocol?
    var coreDataService = CoreDataService()
    
    /// Массив данных, которые отображаются в таблице
    var nameList: [PersonCoreDataModel] = []
    
    /// Добавляет в базу данных элемент
    /// - Parameter name: текст который передаем в базу данных
    func appendName(_ name: String) {
        coreDataService.addName(name: name)
        loadData()
    }
    
    /// Загружает данные из базы данных в массив
    func loadData() {
        nameList = coreDataService.fetchName()
        view?.reloadData()
        print(nameList)
    }
    
    func deleteName(at name: String) {
        coreDataService.deleteCity(name)
        // Удаляем из массива имен, имя которое приходит к нам в функцию
        loadData()
        print(name)
    }
}
