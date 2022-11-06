//
//  PostsViewModel.swift
//  PruebaCeiba
//
//  Created by Sysprobs on 5/11/22.
//

import Foundation

class PostsViewModel {
    //creo el closure para enlazar con la vista
    var refreshData = { () -> () in }
    
    //fuente de datos
    var dataArray: [Posts] = [] {
        didSet {
            refreshData()
            hidenLoading()
        }
    }
    
    func fetchPosts(userId: Int) {

        guard let url = URL(string: "\(API_URL)/posts?userId=\(userId)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let json = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Posts].self, from: json)
                self.dataArray = posts
            } catch let error {
                print("Ha ocurrido un error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
}
