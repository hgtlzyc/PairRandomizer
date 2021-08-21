//
//  NameController.swift
//  PairRandomizer
//
//  Created by lijia xu on 8/20/21.
//

import Foundation


class NamesController {
    
    static let shared = NamesController()
    
    private(set) var names = Names()

    // MARK: - CRUD Functions
    //add new name
    func addNewName(_ name:String) {
        names.baseNames.append(name)
        
        if let _ = names.randomized2DNamesArr.last {
            let count = names.randomized2DNamesArr.count
            names.randomized2DNamesArr[count - 1].append(name)
        } else {
            print("UnExpected case in \(#function)")
        }
        
        saveToPersistanceStore()
    }
    
    func generateNewRandomList(groupSize: Int) {
        
        let randomArr = names.baseNames.shuffled()
        let newRandomized2DArray = randomArr.chunked2DArray(groupSize: groupSize)
        names.randomized2DNamesArr = newRandomized2DArray

        saveToPersistanceStore()
    }
    
    //save group size
    func saveGroupSize(_ size: Int) {
        names.targetGroupSize = size
        
        saveToPersistanceStore()
    }
    
    //update, delete
    func removeNamefromBaseArr(_ name: String) {
        names.baseNames = names.baseNames.filter { $0 != name}
        
        saveToPersistanceStore()
    }
    
    func updateRandom2DArrWith(_ new2DArr: [[String]]) {
        names.randomized2DNamesArr = new2DArr
        
        saveToPersistanceStore()
    }
    
    //update, move
    func moveName(from: (section: Int, row: Int), to: (section: Int, row: Int)) {
        let nameMoved = names.randomized2DNamesArr[from.section][from.row]
        names.randomized2DNamesArr[from.section].remove(at: from.row)
        names.randomized2DNamesArr[to.section].insert(nameMoved, at: to.row)
        
        saveToPersistanceStore()
    }
    
    // MARK: - Data Persis related
    private func saveToPersistanceStore() {
        do {
            let data = try JSONEncoder().encode(names)
            try data.write(to: getPersistenceURL())
        } catch let e {
            print(e)
        }
    }
    
    func loadFromPeristenceStore() {
        do {
            let data = try Data(contentsOf: getPersistenceURL())
            names = try JSONDecoder().decode(Names.self, from: data)
        } catch let e {
            print(e)
        }
    }
    
    private func getPersistenceURL() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Names.json")
        return fileURL
    }
    
    
    // MARK: - Private Init
    private init(){ }
    
}///End of  NameControlelr

fileprivate extension Array {
    
    func chunked2DArray(groupSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: groupSize).map { indexNum in
            Array(self[indexNum ..< Swift.min(indexNum + groupSize, count)])
        }
    }
    
}///End of  Array Extension
