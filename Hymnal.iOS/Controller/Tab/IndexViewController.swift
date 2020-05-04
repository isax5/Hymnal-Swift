//
//  IndexViewController.swift
//  Hymnal.iOS
//
//  Created by Isaac Rebolledo Leal on 28-03-20.
//

import UIKit

class IndexTableViewController: UITableViewController {

    let hymnManager = HymnManager.sharedInstance
    var hymnal: [Hymn]?
    
    
    @IBOutlet weak var indexStyle: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Personalized Row
        tableView.register(UINib(nibName: K.Cell.HymnTextCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.HymnTextIdentifier)
        // Personalized Row's height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = K.Cell.HymnTextHeight
        
        loadItems()
    }
    
    
    
    private func loadItems() {
        
        hymnManager.FetchHymnal(language: hymnManager.debugLanguage) { (hymnal) in
            DispatchQueue.main.async {
                self.hymnal = hymnal
                self.orderItems()
                print("Reload \(self.self) Page with \(hymnal.count) hymns")
            }
        }
    }
    
    private func orderItems() {

        if let hml = hymnal {
            
            switch (indexStyle.selectedSegmentIndex) {
            case 0:
                hymnal = hml.OrderByTitle()
            case 1:
                hymnal = hml.OrderByNumber()
            case 2:
                hymnal = hml
            default:
                hymnal = hml
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func indexStyleChanged(_ sender: UISegmentedControl) {
        print("Order index: \(sender.selectedSegmentIndex) or \(String(describing: sender.titleForSegment(at: sender.selectedSegmentIndex)))")
        
        orderItems()
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


//MARK: - Table View DataSource
extension IndexTableViewController {
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
