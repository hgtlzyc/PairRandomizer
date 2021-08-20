//
//  NameController.swift
//  PairRandomizer
//
//  Created by lijia xu on 8/20/21.
//

import Foundation


enum NamesError: Error {
    case needToLoadFromPS
}


class NamesController {
    
    static let shared = NamesController()
    
    private(set) var names = Names()

    
    // MARK: - CRUD Functions
    
    //Create
    func addNewName(_ name:String) {
        names.baseNames.append(name)
        
        saveToPersistanceStore()
    }
    
    func generateNewRandomList(groupSize: Int) {
        
        let randomArr = names.baseNames.shuffled()
        let newRandomized2DArray = randomArr.chunked2DArray(groupSize: groupSize)
        names.randomized2DNamesArr = newRandomized2DArray

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
