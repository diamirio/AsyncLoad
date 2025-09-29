import Testing
@testable import AsyncLoad

@Suite("Test non-equatable AsyncLoad")
struct AsyncLoadNonEquatableItemTests {
    @Test func testNone() async throws {
        let load1: AsyncLoad<NonEquatableItem> = .none
        let load2: AsyncLoad<NonEquatableItem> = .none
        
        #expect(load1 == load2)
    }
    
    @Test func testLoadedString() async throws {
        var load1: AsyncLoad<NonEquatableItem> = .loaded(NonEquatableItem(name: "Hello"))
        var load2: AsyncLoad<NonEquatableItem> = .loaded(NonEquatableItem(name: "Hello"))
        
        #expect(load1 == load2)
        
        load1 = .loaded(NonEquatableItem(name: "Some"))
        load2 = .loaded(NonEquatableItem(name: "Other"))
        
        #expect(load1 == load2)
    }
    
    @Test func testLoading() async throws {
        let load1: AsyncLoad<User> = .loading
        let load2: AsyncLoad<User> = .loading
        
        #expect(load1 == load2)
    }
    
    @Test func testError() async throws {
        var load1: AsyncLoad<User> = .error(TestingError.some)
        var load2: AsyncLoad<User> = .error(TestingError.some)
        
        #expect(load1 == load2)
        
        load1 = .error(TestingError.some)
        load2 = .error(TestingError.other)
        
        #expect(load1 == load2)
    }
    
    @Test func testMultiple() async throws {
        var load1: AsyncLoad<NonEquatableItem> = .none
        var load2: AsyncLoad<NonEquatableItem> = .none
        
        #expect(load1 == load2)
        
        load1 = .loading
        load2 = .loading
        
        #expect(load1 == load2)
        
        load1 = .loaded(NonEquatableItem(name: "Some"))
        load2 = .loaded(NonEquatableItem(name: "Some"))
        
        #expect(load1 == load2)
        
        load1 = .loaded(NonEquatableItem(name: "Some"))
        load2 = .loaded(NonEquatableItem(name: "Other"))
        
        #expect(load1 == load2)
        
        load1 = .error(TestingError.some)
        load2 = .error(TestingError.some)
        
        #expect(load1 == load2)
    }
}
