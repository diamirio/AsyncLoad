import Testing
@testable import AsyncLoad

@Suite("Test non-equatable AsyncAction")
struct AsyncActionNonEquatableItemTests {
    @Test func testNone() async throws {
        let action1: AsyncAction<NonEquatableItem> = .none
        let action2: AsyncAction<NonEquatableItem> = .none

        #expect(action1 == action2)
    }

    @Test func testLoadedString() async throws {
        var action1: AsyncAction<NonEquatableItem> = .success(NonEquatableItem(name: "Hello"))
        var action2: AsyncAction<NonEquatableItem> = .success(NonEquatableItem(name: "Hello"))

        #expect(action1 == action2)

        action1 = .success(NonEquatableItem(name: "Some"))
        action2 = .success(NonEquatableItem(name: "Other"))

        #expect(action1 == action2)
    }

    @Test func testLoading() async throws {
        let action1: AsyncAction<User> = .loading
        let action2: AsyncAction<User> = .loading

        #expect(action1 == action2)
    }

    @Test func testError() async throws {
        var action1: AsyncAction<User> = .error(TestingError.some)
        var action2: AsyncAction<User> = .error(TestingError.some)

        #expect(action1 == action2)

        action1 = .error(TestingError.some)
        action2 = .error(TestingError.other)

        #expect(action1 == action2)
    }

    @Test func testMultiple() async throws {
        var action1: AsyncAction<NonEquatableItem> = .none
        var action2: AsyncAction<NonEquatableItem> = .none

        #expect(action1 == action2)

        action1 = .loading
        action2 = .loading

        #expect(action1 == action2)

        action1 = .success(NonEquatableItem(name: "Some"))
        action2 = .success(NonEquatableItem(name: "Some"))

        #expect(action1 == action2)

        action1 = .success(NonEquatableItem(name: "Some"))
        action2 = .success(NonEquatableItem(name: "Other"))

        #expect(action1 == action2)

        action1 = .error(TestingError.some)
        action2 = .error(TestingError.some)

        #expect(action1 == action2)
    }
}