import Testing
@testable import AsyncLoad

@Suite("Test non-equatable CachedAsyncLoad")
struct CachedAsyncLoadNonEquatableItemTests {
    @Test<[CachedAsyncLoadParameter<NonEquatableItem>]>("Should be equal (structural)", arguments: [
        .init(.none, .none),
        .init(.loading(), .loading()),
        .init(.loaded(NonEquatableItem(name: "Hello")), .loaded(NonEquatableItem(name: "Different"))),
        .init(.loaded(NonEquatableItem(name: "Some")), .loaded(NonEquatableItem(name: "Other"))),
//        .init(.loading(NonEquatableItem(name: "Some")), .loading(NonEquatableItem(name: "Other"))),
//        .init(.error(nil, TestingError.some), .error(nil, TestingError.some)),
//        .init(.error(nil, TestingError.some), .error(NonEquatableItem(name: "Hello"), TestingError.other)),
//        .init(.error(NonEquatableItem(name: "Hello"), TestingError.some), .error(NonEquatableItem(name: "World"), TestingError.some)),
    ])
    func structuralEquality(param: CachedAsyncLoadParameter<NonEquatableItem>) async throws {
        #expect(param.load1 == param.load2)
    }
}
