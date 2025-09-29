import Testing
@testable import AsyncLoad

@Suite("Test non-equatable CachedAsyncAction")
struct CachedAsyncActionNonEquatableItemTests {
    @Test func testNone() async throws {
        let action1: CachedAsyncAction<NonEquatableItem> = .none
        let action2: CachedAsyncAction<NonEquatableItem> = .none

        #expect(action1 == action2)
    }

    @Test func testLoadedString() async throws {
        var action1: CachedAsyncAction<NonEquatableItem> = .success(NonEquatableItem(name: "Hello"))
        var action2: CachedAsyncAction<NonEquatableItem> = .success(NonEquatableItem(name: "Hello"))

        #expect(action1 == action2)

        action1 = .success(NonEquatableItem(name: "Some"))
        action2 = .success(NonEquatableItem(name: "Other"))

        #expect(action1 == action2)
    }

    @Test func testLoading() async throws {
        let action1: CachedAsyncAction<NonEquatableItem> = .loading()
        let action2: CachedAsyncAction<NonEquatableItem> = .loading()

        #expect(action1 == action2)
    }

    @Test func testError() async throws {
        var action1: CachedAsyncAction<NonEquatableItem> = .error(nil, TestingError.some)
        var action2: CachedAsyncAction<NonEquatableItem> = .error(nil, TestingError.some)

        #expect(action1 == action2)

        action1 = .error(nil, TestingError.some)
        action2 = .error(NonEquatableItem(name: "Hello"), TestingError.other)

        #expect(action1 == action2)
    }

    @Test func testMultiple() async throws {
        var action1: CachedAsyncAction<NonEquatableItem> = .none
        var action2: CachedAsyncAction<NonEquatableItem> = .none

        #expect(action1 == action2)

        action1 = .loading()
        action2 = .loading()

        #expect(action1 == action2)

        action1 = .success(NonEquatableItem(name: "Some"))
        action2 = .success(NonEquatableItem(name: "Some"))

        #expect(action1 == action2)

        action1 = .success(NonEquatableItem(name: "Some"))
        action2 = .success(NonEquatableItem(name: "Other"))

        #expect(action1 == action2)

        action1 = .error(NonEquatableItem(name: "Hello"), TestingError.some)
        action2 = .error(NonEquatableItem(name: "Hello"), TestingError.some)

        #expect(action1 == action2)
    }
}