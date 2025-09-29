import Testing
@testable import AsyncLoad

@Suite("Test non-equatable AsyncAction")
struct AsyncActionNonEquatableItemTests {
    @Test<[AsyncActionParameter<NonEquatableItem>]>("Should be equal (structural)", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.success(NonEquatableItem(name: "Hello")), .success(NonEquatableItem(name: "Different"))),
        .init(.success(NonEquatableItem(name: "Some")), .success(NonEquatableItem(name: "Other"))),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
    ])
    func structuralEquality(param: AsyncActionParameter<NonEquatableItem>) async throws {
        #expect(param.action1 == param.action2)
    }

    @Test<[AsyncActionParameter<User>]>("Should be equal (mixed types)", arguments: [
        .init(.loading, .loading),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
    ])
    func mixedTypeEquality(param: AsyncActionParameter<User>) async throws {
        #expect(param.action1 == param.action2)
    }
}
