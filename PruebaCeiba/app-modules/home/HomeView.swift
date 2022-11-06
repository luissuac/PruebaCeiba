import UIKit

class HomeView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //Instancio viewModel
    var viewModel = HomeViewModel()
    var searchController = UISearchController(searchResultsController: nil)
    var filteredUsrs = [Usuario]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "Prueba de Ingreso"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atras", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.07028970894, green: 0.4611325048, blue: 0.2668374855, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9923083119, green: 0.9923083119, blue: 0.9923083119, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func configureView() {
        showLoading()
        viewModel.fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchController.searchResultsUpdater = self
        self.searchController.definesPresentationContext = true
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()

          self.filteredUsrs.removeAll(keepingCapacity: false)
          guard let searchText = searchController.searchBar.text else {
              return
          }

          let array = viewModel.dataArray.filter {
            return $0.name.contains(searchText)
          }

          self.filteredUsrs = array

          self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.isActive {
            return filteredUsrs.count
        } else {
            return viewModel.dataArray.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewCellTableViewCell        
        
        if searchController.isActive {
            cell.lblNombre.text = filteredUsrs[indexPath.row].name
            cell.lblPhone.text = filteredUsrs[indexPath.row].phone
            cell.lblMail.text = filteredUsrs[indexPath.row].email
            cell.buttonTapCallback = {
                print("Id : \(self.filteredUsrs[indexPath.row].id)")
                self.nextPosts(user: self.filteredUsrs[indexPath.row])
            }
        } else {
            cell.lblNombre.text = viewModel.dataArray[indexPath.row].name
            cell.lblPhone.text = viewModel.dataArray[indexPath.row].phone
            cell.lblMail.text = viewModel.dataArray[indexPath.row].email
            cell.buttonTapCallback = {
                print("Id : \(self.viewModel.dataArray[indexPath.row].id)")
                self.nextPosts(user: self.viewModel.dataArray[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            print(filteredUsrs[indexPath.row].id)
        } else {
            print(viewModel.dataArray[indexPath.row].id)
        }
    }
    
    func nextPosts(user: Usuario) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"PostVC") as! PostsView
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)

    }
}
