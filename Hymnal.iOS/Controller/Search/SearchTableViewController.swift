//
//  SearchTableViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    let hymnManager = HymnManager.sharedInstance
    var hymnArray = [Hymn]()
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Show Search always visible | if its not using, use 'searchController.isActive = true' to make it visible at the beginning
        // The effect is betther when it is after appearing
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Personalized Row
        tableView.register(UINib(nibName: K.Cell.HymnTextCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.HymnTextIdentifier)
        // Personalized Row's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = K.Cell.HymnTextHeight
        
        
        loadItems()
    }
    
    var loadedBefore = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !loadedBefore {
            loadedBefore = true
            
            DispatchQueue.main.async {
                // make it visible at the beginning
                //            self.searchController.isActive = true
                self.searchController.searchBar.becomeFirstResponder()
                
            }
        }
    }
    
    func loadItems() {
        
        hymnManager.FetchHymnal(language: hymnManager.debugLanguage) { (hymnal) in
            DispatchQueue.main.async {
                self.hymnArray = hymnal.OrderByNumber()
                self.tableView.reloadData()
                print("Reload \(self.self) Page with \(hymnal.count) hymns")
            }
        }
    }
    
    
    // MARK: - Navigation
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
        struct Holder {
            static var previousQuery = ""
        }
        
        if let query = searchController.searchBar.text, query != Holder.previousQuery {
            Holder.previousQuery = query
            
            print("Search: \(query)")
            
            if query == "" {
                loadItems()
            } else {
                
                hymnManager.FetchHymnal(language: hymnManager.debugLanguage) { (hymnal) in
                    DispatchQueue.main.async {
                        self.hymnArray = hymnal.filter({ (hymn) -> Bool in
                            if let _ =  hymn.Title.range(of: query, options: .caseInsensitive) {
                                return true
                            } else {
                                return false
                            }
                        }).OrderByNumber()
                        
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        
    }
}

//MARK: - TableView DataSource & Delegate
extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hymnArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.HymnTextIdentifier, for: indexPath) as! HymnTextTableViewCell
        
        let hymn = hymnArray[indexPath.row]
        cell.title.text = hymn.Title
        
        // TODO: Allow just 10 first words and without '\n' for subtitle
        cell.subtitle.text = hymn.Content
        cell.number.text = String(hymn.Number)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let hymn = hymnArray[indexPath.row]
        self.performSegue(withIdentifier: K.Segue.ShowHymn, sender: hymn)
    }
}
