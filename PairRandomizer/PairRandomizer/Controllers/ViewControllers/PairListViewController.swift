//
//  PairListViewController.swift
//  PairRandomizer
//
//  Created by lijia xu on 8/20/21.
//

import UIKit

class PairListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var randomized2dArray = [[String]]()
    
    var groupSize: Int = 2
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        laod2DArrFromNamesController(isInitialLoad: true)
        setupViews()
    }
    
    func setupViews() {
        tableView.separatorStyle = .none
    }
    
    @IBAction func addNewNameTapped(_ sender: Any) {
        presentAddNewNameAlert()
        
    }///End of  addNewNameTapepd
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        
        NamesController.shared.generateNewRandomList(groupSize: groupSize)
        laod2DArrFromNamesController(isInitialLoad: false)
        
    }///End of  randomizeButtonTapped
    
}///End of  PairListViewController

// MARK: - TableView RElated
extension PairListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        randomized2dArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        randomized2dArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch randomized2dArray[section].count {
        case groupSize:
            return "Group \(section + 1)"
        case 1...groupSize:
            return "Group \(section + 1) (missing)"
        case 0:
            return nil
        default:
            print("Unexpected case in \(#function)")
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath)
        
        cell.textLabel?.text = randomized2dArray[indexPath.section][indexPath.row]
        
        return cell
    }
    
    // MARK: - delete related
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let removedPerson = randomized2dArray[indexPath.section].remove(at: indexPath.row)
            
            NamesController.shared.updateRandom2DArrWith(randomized2dArray)
            NamesController.shared.removeNamefromBaseArr(removedPerson)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadSections([indexPath.section], with: .none)
        }
        
    }///End of  editing style

}///End of  tableView delegate Extension

// MARK: - Data Related
extension PairListViewController {
    
    func laod2DArrFromNamesController(isInitialLoad: Bool) {
        switch isInitialLoad {
        case true:
            NamesController.shared.loadFromPeristenceStore()
            randomized2dArray = NamesController.shared.names.randomized2DNamesArr
            
        case false:
            randomized2dArray = NamesController.shared.names.randomized2DNamesArr
            tableView.reloadData()
        }///End of  switch
    
    }///End of  laodDataFromNamesController
    
}///End of  data related extension

// MARK: - Alert Related
extension PairListViewController {
    
    func presentAddNewNameAlert() {
        let alerVC = UIAlertController(title: "Add Person", message: "Add someone new to the list", preferredStyle: .alert)
        
        alerVC.addTextField { txField in
            txField.placeholder = "Full Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let personName = alerVC.textFields?.first?.text, !personName.isEmpty else { return }
            
            NamesController.shared.addNewName(personName)
            NamesController.shared.generateNewRandomList(groupSize: self.groupSize)
            
            self.laod2DArrFromNamesController(isInitialLoad: false)
        }
        alerVC.addAction(cancelAction)
        alerVC.addAction(addAction)
        present(alerVC, animated: true)
    }

}///End of  alert related Extension
