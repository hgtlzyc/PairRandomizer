//
//  PairListViewController.swift
//  PairRandomizer
//
//  Created by lijia xu on 8/20/21.
//

import UIKit


class PairListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    private var randomized2dArray = [[String]]()
    
    private var groupSize: Int = 2
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        laod2DArrFromNamesController(isInitialLoad: true)
        setupViews()
    }
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing.toggle()
        editBarButton.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @IBAction func addNewNameTapped(_ sender: Any) {
        presentTwoActionsAlertFor(mode: .addNewPerson)
        
    }
    
    @IBAction func changeGroupSizeButtonTapped(_ sender: Any) {
        presentTwoActionsAlertFor(mode: .changeGroupSize)
        
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        NamesController.shared.generateNewRandomList(groupSize: groupSize)
        laod2DArrFromNamesController(isInitialLoad: false)
        
    }
    
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
        case let x where x > groupSize:
            return "Group \(section + 1) (extra)"
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
    
    // MARK: - Rearrange Related
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        NamesController.shared.moveName(
            from: (section: sourceIndexPath.section, row: sourceIndexPath.row),
            to: (section: destinationIndexPath.section, row: destinationIndexPath.row)
        )
        
        laod2DArrFromNamesController(isInitialLoad: false)
    }///End of  moveRowAt
    
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

// MARK: - Load Data Related
extension PairListViewController {
    
    private func laod2DArrFromNamesController(isInitialLoad: Bool) {
    
        switch isInitialLoad {
        case true:
            NamesController.shared.loadFromPeristenceStore()
            load2DArray()
            
        case false:
            load2DArray()
            tableView.reloadData()
        }///End of  switch
    
    }///End of  laodDataFromNamesController
    
    private func load2DArray(){
        randomized2dArray = NamesController.shared.names.randomized2DNamesArr
        if let targetGroupSize = NamesController.shared.names.targetGroupSize {
            groupSize = targetGroupSize
            title = "Group Size 👉🏻 \(groupSize)"
        }
    }
    
}///End of  data related extension

// MARK: - View Setup/Update Related
extension PairListViewController {
    
    private func setupViews() {
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
    }
    
}

// MARK: - Alert Related
extension PairListViewController {
    
    private enum AlerPresentMode {
        case addNewPerson
        case changeGroupSize
    }
    
    private func presentTwoActionsAlertFor(mode: AlerPresentMode) {
        var alertTitle: String
        var alertMessage: String
        var confirmActionTitle: String
        
        switch mode {
        case .addNewPerson:
            alertTitle = "Add Person"
            alertMessage = "Add someone new to the list"
            confirmActionTitle = "Add"
            
        case .changeGroupSize:
            alertTitle = "Change Group Size"
            alertMessage = "Enter Size Here"
            confirmActionTitle = "Change"
            
        }///End of  switch model
        
        let alerVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        var nameTxField: UITextField?
        var groupSizeTxField: UITextField?
        
        switch mode {
        case .addNewPerson:
            alerVC.addTextField { txField in
                nameTxField = txField
                txField.placeholder = "Full Name (Required)"
            }
            
        case .changeGroupSize:
            alerVC.addTextField { txField in
                groupSizeTxField = txField
                txField.placeholder = "Group Size"
            }
            
        }///End of  switch mode for txField
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
            defer {
                self.laod2DArrFromNamesController(isInitialLoad: false)
            }
            
            switch mode {
            case .addNewPerson:
                guard let personName = nameTxField?.text, !personName.isEmpty else { return }
                NamesController.shared.addNewName(personName)
                break
                    
            case .changeGroupSize:
                guard let targetSizeTx = groupSizeTxField?.text,
                      let targetGroupSizeInt = Int(targetSizeTx),
                      targetGroupSizeInt > 0 else { return }
                NamesController.shared.saveGroupSize(targetGroupSizeInt)
                
            }///End of  switch mode
            
        }///End of  ConfirmAction
        
        alerVC.addAction(cancelAction)
        alerVC.addAction(confirmAction)
        
        present(alerVC, animated: true)
    }///End of  presentChangeSettingAlert

}///End of  alert related Extension
