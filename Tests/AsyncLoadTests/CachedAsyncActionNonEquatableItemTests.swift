import Testing
@testable import AsyncLoad

@Suite("Test non-equatable CachedAsyncAction")
struct CachedAsyncActionNonEquatableItemTests {
    @Test<[CachedAsyncActionParameter<NonEquatableItem>]>("Should be equal (structural)", arguments: [
        .init(.none, .none),
        .init(.loading(), .loading()),
        .init(.success(NonEquatableItem(name: "Hello")), .success(NonEquatableItem(name: "Different"))),
        .init(.success(NonEquatableItem(name: "Some")), .success(NonEquatableItem(name: "Other"))),
        .init(.loading(NonEquatableItem(name: "Some")), .loading(NonEquatableItem(name: "Other"))),
        .init(.error(nil, TestingError.some), .error(nil, TestingError.some)),
        .init(.error(nil, TestingError.some), .error(NonEquatableItem(name: "Hello"), TestingError.other)),
        .init(.error(NonEquatableItem(name: "Hello"), TestingError.some), .error(NonEquatableItem(name: "World"), TestingError.some)),
    ])
    func structuralEquality(param: CachedAsyncActionParameter<NonEquatableItem>) async throws {
        #expect(param.action1 == param.action2)
    }
}
