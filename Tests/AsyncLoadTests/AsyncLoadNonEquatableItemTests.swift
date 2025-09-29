import Testing
@testable import AsyncLoad

@Suite("Test non-equatable AsyncLoad")
struct AsyncLoadNonEquatableItemTests {
    @Test<[AsyncLoadParameter<NonEquatableItem>]>("Should be equal (structural)", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.loaded(NonEquatableItem(name: "Hello")), .loaded(NonEquatableItem(name: "Different"))),
        .init(.loaded(NonEquatableItem(name: "Some")), .loaded(NonEquatableItem(name: "Other"))),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
    ])
    func structuralEquality(param: AsyncLoadParameter<NonEquatableItem>) async throws {
        #expect(param.load1 == param.load2)
    }

    @Test<[AsyncLoadParameter<User>]>("Should be equal (mixed types)", arguments: [
        .init(.loading, .loading),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
    ])
    func mixedTypeEquality(param: AsyncLoadParameter<User>) async throws {
        #expect(param.load1 == param.load2)
    }
}
