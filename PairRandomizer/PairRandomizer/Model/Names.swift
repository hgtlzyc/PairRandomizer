//
//  Names.swift
//  PairRandomizer
//
//  Created by lijia xu on 8/20/21.
//

import Foundation

class Names: Codable {
    
    var baseNames: [String]
    var randomized2DNamesArr: [[String]]
    
    internal init(baseNames: [String] = [], randomized2DNamesArr: [[String]] = [[]]) {
        self.baseNames = baseNames
        self.randomized2DNamesArr = randomized2DNamesArr
    }
    
}
