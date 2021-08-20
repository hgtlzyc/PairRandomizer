//
//  PairListViewController.swift
//  PairRandomizer
//
//  Created by lijia xu on 8/20/21.
//

import UIKit

class PairListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let baseNamesArr = ["a", "b", "c", "d", "e"]
    
    var randomArr: [String] = []
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        setupViews()
    }
    
    func setupViews() {
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func addNewNameTapped(_ sender: Any) {
        
        
    }///End of  addNewNameTapepd
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        
        
    }///End of  randomizeButtonTapped
    
}///End of  PairListViewController

// MARK: - TableView RElated
extension PairListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }///End of  editing style

}///End of  tableView delegate Extension
