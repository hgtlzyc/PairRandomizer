import UIKit

let baseArray: [String] = ["a", "b", "c", "d", "e"]

let randomArray = baseArray.shuffled()
let groupSize: Int = 2

let chunked2DArray = stride(from: 0, to: randomArray.count, by: groupSize).map { indexNum in
    Array(randomArray[indexNum ..< min(indexNum + groupSize, randomArray.count)])
}

print(chunked2DArray)
