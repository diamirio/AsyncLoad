import Foundation

enum TestingError: Error {
    case some
    case other
}

class NonEquatableItem {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct User: Equatable {
    let name: String
}
