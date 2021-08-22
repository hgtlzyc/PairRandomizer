//: [Previous](@previous)

import Foundation

enum TestEnum: Comparable {
    case caseTest1
    case caseTest2(Int)
    case caseTest3(String)
}

let test1 = TestEnum.caseTest1
let test2 = TestEnum.caseTest2(5)
let test3 = TestEnum.caseTest3("1")

print(test1 < test2)
print(test2 < test3)




//: [Next](@next)
