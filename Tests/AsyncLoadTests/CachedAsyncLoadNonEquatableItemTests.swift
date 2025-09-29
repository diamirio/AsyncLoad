import Testing
@testable import AsyncLoad

@Suite("Test non-equatable CachedAsyncLoad")
struct CachedAsyncLoadNonEquatableItemTests {
    @Test func testNone() async throws {
        let load1: CachedAsyncLoad<NonEquatableItem> = .none
        let load2: CachedAsyncLoad<NonEquatableItem> = .none
        
        #expect(load1 == load2)
    }
    
    @Test func testLoadedString() async throws {
        var load1: CachedAsyncLoad<NonEquatableItem> = .loaded(NonEquatableItem(name: "Hello"))
        var load2: CachedAsyncLoad<NonEquatableItem> = .loaded(NonEquatableItem(name: "Hello"))
        
        #expect(load1 == load2)
        
        load1 = .loaded(NonEquatableItem(name: "Some"))
        load2 = .loaded(NonEquatableItem(name: "Other"))
        
        #expect(load1 == load2)
    }
    
    @Test func testLoading() async throws {
        let load1: CachedAsyncLoad<NonEquatableItem> = .loading()
        let load2: CachedAsyncLoad<NonEquatableItem> = .loading()
        
        #expect(load1 == load2)
    }
    
    @Test func testError() async throws {
        var load1: CachedAsyncLoad<NonEquatableItem> = .error(nil, TestingError.some)
        var load2: CachedAsyncLoad<NonEquatableItem> = .error(nil, TestingError.some)
        
        #expect(load1 == load2)
        
        load1 = .error(nil, TestingError.some)
        load2 = .error(NonEquatableItem(name: "Hello"), TestingError.other)
        
        #expect(load1 == load2)
    }
    
    @Test func testMultiple() async throws {
        var load1: CachedAsyncLoad<NonEquatableItem> = .none
        var load2: CachedAsyncLoad<NonEquatableItem> = .none
        
        #expect(load1 == load2)
        
        load1 = .loading()
        load2 = .loading()
        
        #expect(load1 == load2)
        
        load1 = .loaded(NonEquatableItem(name: "Some"))
        load2 = .loaded(NonEquatableItem(name: "Some"))
        
        #expect(load1 == load2)
        
        load1 = .loaded(NonEquatableItem(name: "Some"))
        load2 = .loaded(NonEquatableItem(name: "Other"))
        
        #expect(load1 == load2)
        
        load1 = .error(NonEquatableItem(name: "Hello"), TestingError.some)
        load2 = .error(NonEquatableItem(name: "Hello"), TestingError.some)
        
        #expect(load1 == load2)
    }
}
