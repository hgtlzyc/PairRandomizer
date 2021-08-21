# PairRandomizer
### My solution to the code challange
- Generate random groups based on the target group size
- Change target group size
- Rearrange the list
- Delete/Add Names
- Persistance 

![](https://github.com/hgtlzyc/PairRandomizer/blob/d60b063ce473a05d5e284c725942711acde81692/ScreenCapture.gif)

Code Snippet:
``` swift

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


```

Names Controller [Link](https://github.com/hgtlzyc/PairRandomizer/blob/main/PairRandomizer/PairRandomizer/Controllers/ModelControllers/NamesController.swift)
