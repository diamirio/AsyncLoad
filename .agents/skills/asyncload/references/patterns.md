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

```swift
@Test func loadedExposesItem() {
    let state = AsyncLoad<User>.loaded(User(name: "Ann"))
    #expect(state.item == User(name: "Ann"))
    #expect(state.error == nil)
}

@Test func errorsCompareEqual() {
    #expect(AsyncLoad<User>.error(TestingError.some) == .error(TestingError.other))
}
```

Test the view model (or reactor) that produces the states: assert `.loading` is set before the call and `.loaded`/`.error` after, using a mock service.
