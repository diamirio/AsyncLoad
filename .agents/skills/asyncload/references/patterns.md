# Patterns

## In a view model

```swift
import AsyncLoad
import Observation

protocol ProfileServiceProtocol: Sendable {
    func profile() async throws -> Profile
    func deleteProfile() async throws
}

@MainActor
@Observable
final class ProfileViewModel {
    var profile = CachedAsyncLoad<Profile>.none
    var delete = AsyncLoadNoContent.none

    private let service: ProfileServiceProtocol

    init(service: ProfileServiceProtocol) {
        self.service = service
    }

    func load() async {
        profile = .loading(profile.item)
        do {
            profile = .loaded(try await service.profile())
        } catch is CancellationError {
            return
        } catch {
            profile = .error(profile.item, error)
        }
    }

    func deleteProfile() async {
        delete = .loading
        do {
            try await service.deleteProfile()
            delete = .loaded
        } catch {
            delete = .error(error)
        }
    }
}
```

The same pattern works inside a reactor's `action(_:)`; for AsyncReactor see the `asyncreactor` skill if it is available.

View:

```swift
CachedAsyncLoadView(viewModel.profile) { profile in
    ProfileContent(profile: profile)
} loading: { profile in
    ProfileContent(profile: profile).overlay { ProgressView() }
} error: { profile, error in
    ErrorCallout(error)
}
.task { await viewModel.load() }
```

Observe success of a write via its item: `.onChange(of: viewModel.delete.item) { … }`.

## Composite screens

For a screen with several requests, keep one `AsyncLoad` per request and combine in the view; do not invent a "screen state" enum that duplicates them.

## Testing

Test the view model (or reactor) that produces the states, with Swift Testing and a stubbed service. Do not test `AsyncLoad` itself.

**Pitfall: `==` ignores the error.** `AsyncLoad.error(a) == .error(b)` is always `true`, and `CachedAsyncLoad.error(item, a) == .error(item, b)` compares only the cached item. Never assert an error state with `== .error(x)`; check the error itself:

```swift
import AsyncLoad
import Foundation
import Testing
@testable import MyApp

@MainActor
struct ProfileViewModelTests {
    let service = ProfileServiceStub()

    @Test("Failed refresh keeps the cached profile and stores the error")
    func refreshFailureKeepsCachedProfile() async {
        // Given
        service.profileResult = .success(.fixture(name: "Ann"))
        let sut = ProfileViewModel(service: service)
        await sut.load()
        service.profileResult = .failure(URLError(.notConnectedToInternet))

        // When
        await sut.load()

        // Then
        #expect(sut.profile.item == .fixture(name: "Ann"))
        #expect((sut.profile.error as? URLError)?.code == .notConnectedToInternet)
    }

    @Test("Delete without content ends in loaded")
    func deleteSuccess() async {
        // Given
        let sut = ProfileViewModel(service: service)

        // When
        await sut.deleteProfile()

        // Then
        #expect(sut.delete == .loaded)
    }
}
```

- `.loaded` / `.loading` / `.none` compare by value and can be asserted with `==`. For `.error`, use `.error` (the `Error?` property) and check its type or code.
- Intermediate `.loading` state: keep the stub's request pending, assert `isLoading`, then let it finish. See the `asyncreactor` skill's testing reference for a pending stub.
- `CancellationError` must leave the state unchanged; cover it when the code has a `catch is CancellationError` branch.
