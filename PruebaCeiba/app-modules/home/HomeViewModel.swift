//
//  HomeViewModel.swift
//  PruebaCeiba
//
//  Created by Sysprobs on 4/11/22.
//

import Foundation
import UIKit
import CoreData

class HomeViewModel {
    
    //creo el closure para enlazar con la vista
    var refreshData = { () -> () in }

    
    //fuente de datos
    var dataArray: [Usuario] = [] {
        didSet {
            refreshData()
            hidenLoading()
        }
    }
    
    func fetchData() {
        let usersEntity = getEntity()
        print("Contador Entity: \(usersEntity.count)")
        if usersEntity.count > 0 {
            self.dataArray = usersEntity
        } else {
            fetchUsers()
        }
    }
    
    func fetchUsers() {

        guard let url = URL(string: "\(API_URL)/users") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let json = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let fullUser = try decoder.decode([FullUser].self, from: json)
                var users = [Usuario]()
                for a in fullUser {
                    let user = Usuario(id: a.id, name: a.name, email: a.email, phone: a.phone)
                    users.append(user)
                }
                self.dataArray = users
                DispatchQueue.main.async {
                    self.saveEntity(userArray: self.dataArray)
                }
                
            } catch let error {
                print("Ha ocurrido un error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    func saveEntity(userArray: [Usuario]) {
            
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for a in userArray {
            
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
            let record = NSManagedObject(entity: entity, insertInto: managedContext)
            
            record.setValue(a.id, forKey: "id")
            record.setValue(a.name, forKey: "nombre")
            record.setValue(a.email, forKey: "email")
            record.setValue(a.phone, forKey: "telefono")

        }
    
        do {
            try managedContext.save()
        } catch
        let error as NSError {
            print("Could not save. \(error),\(error.userInfo)")
        }
    }
        
    func getEntity() -> [Usuario] {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        var usuarios = [Usuario]()
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for a in objects {
                let usuario = Usuario(id: a.value(forKey: "id") as! Int, name: a.value(forKey: "nombre") as! String, email: a.value(forKey: "email") as! String, phone: a.value(forKey: "telefono") as! String)
                usuarios.append(usuario)
            }
            return usuarios
        } catch
            let error as NSError {
                print("Could not load. \(error),\(error.userInfo)")
            return []
        }
        
    }
}
