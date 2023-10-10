import SwiftUI
import PlaygroundSupport

struct Person{
    var name: String
    var age: Int
    
    func test(){
        print("\(Person.Type.self)")
    }
}

let p = Person(name: "mjt", age: 18)

p.test()
