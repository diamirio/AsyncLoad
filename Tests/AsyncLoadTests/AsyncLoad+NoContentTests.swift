//
//  AsyncLoad+NoContentTests.swift
//  AsyncLoad
//
//  Created by Alexander Kauer on 30.10.25.
//

import Foundation
import Testing

@Suite("Test no content AsyncLoad")
struct AsyncLoadNoContentTests {
    
    @Test<[AsyncLoadNoContentParameter]>("Should be equal", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.loaded, .loaded),
        .init(.error(TestingError.some), .error(TestingError.some)),
    ])
    func noContentEqual(_ parameter: AsyncLoadNoContentParameter) {
        #expect(parameter.load1 == parameter.load2)
    }
    
    
    @Test<[AsyncLoadNoContentParameter]>("Should not be equal", arguments: [
        .init(.none, .loading),
        .init(.loading, .loaded),
        .init(.loaded, .error(TestingError.some)),
        .init(.error(TestingError.some), .none),
    ])
    func noContentNotEqual(_ parameter: AsyncLoadNoContentParameter) {
        #expect(parameter.load1 != parameter.load2)
    }
}
