//
//  RecordsViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 05-05-20.
//

import UIKit

class RecordsViewController: UIViewController {
    
    let hymnManager = HymnManager.sharedInstance
    var hymnal: [Hymn]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Personalized Row
        tableView.register(UINib(nibName: K.Cell.HymnTextCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.HymnTextIdentifier)
        // Personalized Row's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = K.Cell.HymnTextHeight
        
        loadItems()
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

//MARK: - TableView DataSource & Delegate
extension RecordsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hml = hymnal {
            return hml.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let hymn = hymnal?[indexPath.row] else { return }
        self.performSegue(withIdentifier: K.Segue.ShowHymn, sender: hymn)
    }

}
