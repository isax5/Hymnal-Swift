//
//  IndexViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class IndexTableViewController: UITableViewController {
    
    let hymnManager = HymnManager.sharedInstance
    var hymnArray = [Hymn]()
    
    let searchController = UISearchController()
    
    @IBOutlet weak var indexStyle: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        
        // Personalized Row
        tableView.register(UINib(nibName: K.Cell.HymnTextCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.HymnTextIdentifier)
        // Personalized Row's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = K.Cell.HymnTextHeight
        
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func loadItems() {
        
        hymnManager.FetchHymnal(language: hymnManager.debugLanguage) { (hymnal) in
            
            self.hymnArray = hymnal
            self.orderItems()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("Reload \(self.self) Page with \(hymnal.count) hymns")
            
        }
    }
    
    private func orderItems() {
        
        switch (indexStyle.selectedSegmentIndex) {
        case 0:
            hymnArray = hymnArray.OrderByTitle()
        case 1:
            hymnArray = hymnArray.OrderByNumber()
        case 2:
            break;
        default:
            break;
        }
    }
    
    //MARK: - UISegmentedControl - Order
    @IBAction func indexStyleChanged(_ sender: UISegmentedControl) {
        print("Order index: \(sender.selectedSegmentIndex) or \(String(describing: sender.titleForSegment(at: sender.selectedSegmentIndex)))")
        
        orderItems()
        tableView.reloadData()
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
extension IndexTableViewController: UISearchResultsUpdating {
    
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
                    
                    self.hymnArray = hymnal.filter({ (hymn) -> Bool in
                        if let _ =  hymn.Title.range(of: query, options: .caseInsensitive) {
                            return true
                        } else {
                            return false
                        }
                    })
                    
                    self.orderItems()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        
    }
}

//MARK: - Table View DataSource
extension IndexTableViewController {
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
