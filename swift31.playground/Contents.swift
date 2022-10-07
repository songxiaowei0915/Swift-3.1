import Foundation

let a = 2.0
let b = Int(a)
let c = Int(exactly: a)

struct Apple {
    var weightInGaram: Int
    
    init? (json: [String: Any]) {
        guard let weightInString = json["weight"] as? String,
                let weightInDouble = Double(weightInString),
              let weight = Int(exactly: weightInDouble) else {
                  return nil
              }
        
        self.weightInGaram = weight
    }
}

let applesData = "[{\"weight\":\"500.0\"},{\"weight\":\"500.1\"},{\"weight\":\"499.9\"}]"
let data = applesData.data(using: .utf8)!

func filterApple(from data:Data) -> [Apple] {
    guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
          let dataArray = json as? [[String: Any]] else {
        return []
    }
    
    return dataArray.flatMap(Apple.init)
}

let apples = filterApple(from: data)
print(apples.count)
apples.forEach { print($0) }

let factorialArray = sequence(state: (1,1), next: {
    (state: inout (Int, Int)) -> Int in
    
    defer {
        state.0 = state.0 * state.1
        state.1 += 1
    }
    
    return state.0
})

factorialArray
    .prefix(while: { $0 < 10000})
    .drop { $0 < 100 }
    .forEach{print($0)}


func increaseValue(in array:[Int], with: () -> Int) {
    withoutActuallyEscaping(with) {
        escapeWith in
        let increaseArray = array.lazy.map { $0 + escapeWith() }
        
        print(increaseArray[0])
        print(increaseArray[1])
    }
}

print("================")
increaseValue(in: [1, 2, 3, 4, 5], with: { return 2})

#if swift(<3.1)
func foo() {}
#elseif swift(>=3.0)
func bar() {}
#endif

@available(swift, introduced: 3.0, obsoleted: 3.1)
func baz() {}

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

print(3.isEven)
print(4.isEven)

//protocol IntValue {
//    var value: Int { get }
//}
//
//extension Int: IntValue {
//    var value: Int { return self }
//}

extension Optional where Wrapped == Int {
    var isEven: Bool {
        guard let value = self else {
            return false
        }
        
        return value % 2 == 0
    }
}

var foo: Int? = 3
print(foo.isEven)

print("===========================")

class List<T> {
    class Node: CustomStringConvertible {
        var value: T
        var next: Node?
        
        init(value: T, next: Node?) {
            self.value = value
            self.next = next
        }
        
        var description: String {
            var nextText = "End"
            
            if let next = self.next {
                nextText = "\(next.value)"
            }
            
            return "[value: \(self.value) next: \(nextText)]"
        }
    }
    
    class Storage<U> {
        var head: U? = nil
        var curr: U? = nil
    }
    
    var storage: Storage<Node> = Storage()
    var count = 0
    
    func push(element: T) {
        let node = Node(value: element, next: nil)
        
        if storage.head == nil {
            storage.head = node
        }
        
        if storage.curr != nil {
            storage.curr!.next = node
        }
        
        storage.curr = node
        count += 1
    }
}

extension List: CustomStringConvertible {
    var description: String {
        var desc = ""
        
        var pos = storage.head
        
        while pos != nil {
            desc += (pos!.description + "\n")
            pos = pos!.next
        }
        
        return desc
    }
}

var l = List<Int>()
l.push(element: 2)
l.push(element: 3)
l.push(element: 4)
l.push(element: 5)
print(l)
