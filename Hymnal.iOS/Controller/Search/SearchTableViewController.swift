//
//  SearchTableViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    let hymnManager = HymnManager.sharedInstance
    var hymnal: [Hymn]?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Personalized Row
        tableView.register(UINib(nibName: K.Cell.HymnTextCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.HymnTextIdentifier)
        // Personalized Row's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = K.Cell.HymnTextHeight
        
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        searchController.becomeFirstResponder()
//        searchController.searchBar.becomeFirstResponder()
//        searchController.searchBar.searchTextField.becomeFirstResponder()
    }
    
    func loadItems() {
        
        hymnManager.FetchHymnal(language: hymnManager.debugLanguage) { (hymnal) in
            DispatchQueue.main.async {
                self.hymnal = hymnal.OrderByNumber()
                self.tableView.reloadData()
                print("Reload \(self.self) Page with \(hymnal.count) hymns")
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: Make standard segue preparation for this specific implementation
        switch segue.identifier {
        case K.Segue.ShowHymn:
            if let navVC = segue.destination as? UINavigationController,
                let destination = navVC.viewControllers.first as? HymnViewController,
                let h = sender as? Hymn {
                
                destination.hymn = h
            }
            
        default:
            break
        }
    }

}

//MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}

//MARK: - Table view DataSource
extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hml = hymnal {
            return hml.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.HymnTextIdentifier, for: indexPath) as! HymnTextTableViewCell
        
        if let hml = hymnal {
            let hymn = hml[indexPath.row]
            cell.title.text = hymn.Title
            
            // TODO: Allow just 10 first words and without '\n' for subtitle
            cell.subtitle.text = hymn.Content
            cell.number.text = String(hymn.Number)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let hymn = hymnal?[indexPath.row] else { return }
        self.performSegue(withIdentifier: K.Segue.ShowHymn, sender: hymn)
    }
}
