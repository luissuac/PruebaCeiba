//
//  PostsTableViewController.swift
//  Prueba-Ingreso
//
//  Created by LUIS SUAREZ on 13/04/21.
//

import UIKit

class PostsView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    var viewModel = PostsViewModel()
    var user: Usuario? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bind()
    }
    
    private func initView(){

        tableView.delegate = self
        tableView.dataSource = self
        
        lblNombre.text = user?.name
        lblPhone.text = user?.phone
        lblEmail.text = user?.email
        
        viewHeader.layer.borderColor = #colorLiteral(red: 0.07028970894, green: 0.4611325048, blue: 0.2668374855, alpha: 1)
        viewHeader.layer.borderWidth = 1
        
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0.07028970894, green: 0.4611325048, blue: 0.2668374855, alpha: 1)
        
        viewModel.fetchPosts(userId: user?.id ?? 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.title = "Posts"//Create this String variable.
        
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}

extension PostsView: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.dataArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as! PostsViewCell
        
        let tittle = viewModel.dataArray[indexPath.row].title
        let content = "\n \n \(viewModel.dataArray[indexPath.row].body)"

        let attributedText = NSMutableAttributedString(string: tittle, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.07028970894, green: 0.4611325048, blue: 0.2668374855, alpha: 1)])
        attributedText.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))

        let roundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 30, height: 240))
        roundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        roundedView.layer.masksToBounds = false
        roundedView.layer.cornerRadius = 2.0
        roundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        roundedView.layer.shadowOpacity = 0.2

        cell.txtPosts.attributedText = attributedText
        cell.contentView.backgroundColor = UIColor.clear
        cell.contentView.addSubview(roundedView)
        cell.contentView.sendSubviewToBack(roundedView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }

}
