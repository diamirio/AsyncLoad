---
name: asyncload
description: Model async request state with diamirio/AsyncLoad — AsyncLoad<T> (.none/.loading/.loaded/.error), AsyncLoadNoContent for operations without data, CachedAsyncLoad<T> for refreshes that keep stale data, and the SwiftUI views AsyncLoadView and CachedAsyncLoadView. Use when a project imports AsyncLoad, when writing or reviewing loading/error state in a reactor or view model, when choosing between AsyncLoad and CachedAsyncLoad, when rendering loading and error states, or when replacing isLoading/error/data flags.
---

# AsyncLoad

One enum per request instead of separate `isLoading` / `error` / `data` properties. Package `diamirio/AsyncLoad`, product and module `AsyncLoad` (includes the SwiftUI views). Requires Swift 6.1+, iOS 16 / macOS 13 / watchOS 9 / visionOS 1. It has no dependencies and works with any architecture (plain `@Observable` view models, reactors, …). For using it inside an AsyncReactor reactor, see the `asyncreactor` skill if it is available.

Source of truth: `Sources/AsyncLoad` — read it when unsure.

## Types

| Type | Cases | Use |
|---|---|---|
| `AsyncLoad<T>` | `.none`, `.loading`, `.loaded(T)`, `.error(Error)` | A request whose result replaces the previous one. |
| `AsyncLoadNoContent` (= `AsyncLoad<NoContent>`) | same, `.loaded` without payload | Delete / mark-as-read / save — success or failure only. |
| `CachedAsyncLoad<T>` | `.none`, `.loading(T?)`, `.loaded(T)`, `.error(T?, Error)` | Refreshes and stale-while-revalidate: keep showing the last data while loading or after an error. |

`T` must be `Equatable & Sendable`. `AsyncLoad<Void>` is not supported — use `AsyncLoadNoContent`.

Built-in projections (all types): `isLoading`, `item`, `error`. `AsyncLoad.item` is non-nil only for `.loaded`; `CachedAsyncLoad.item` is also non-nil for `.loading(item)` and `.error(item, _)`.

## Loading pattern

```swift
state.profile = .loading
do {
    state.profile = .loaded(try await api.profile())
} catch {
    state.profile = .error(error)
}
```

- Set `.loading` before the async work, `.loaded` / `.error` after.
- With cancellation (new request replaces old one) do not publish `.error` for cancelled work; just return. `URLSession` throws `URLError(.cancelled)` rather than `CancellationError`, so handle both or check `Task.isCancelled` before writing state.
- `AsyncLoadNoContent`: `state.delete = .loading` … `state.delete = .loaded` (static `.loaded` convenience, no payload).

Cached pattern:

```swift
state.profile = .loading(state.profile.item)       // keeps stale data visible
do {
    state.profile = .loaded(try await api.profile())
} catch {
    state.profile = .error(state.profile.item, error)
}
```

## Views

`AsyncLoadView(state) { item in … } error: { error in … }`

- Shows `content(item)` only when `.loaded`; shows a centered `ProgressView` for `.none` and `.loading`; shows `error` content for `.error`. The error closure is optional — default is `Text(error.localizedDescription)`.
- The content closure receives a **non-optional** `Item`.
- There is no empty state and no retry button; render empty collections inside `content`, add retry in your `error` closure.
- Going `.loaded` → `.loading` hides the content (a spinner replaces it). For refresh-in-place use `CachedAsyncLoad`.

`CachedAsyncLoadView(state) { item in … } loading: { item? in … } error: { item?, error in … }`

- All three closures are required. `.none` calls `loading(nil)`.
- Use the cached item in `loading`/`error` to keep stale content visible (dimmed, with a spinner or error callout).

## Rules

- One value per request; do not mirror it with `isLoading`, `errorMessage`, `didLoad` booleans. Read `state.isLoading`, `state.item`, `state.error` directly.
- Collection results: `AsyncLoad<[Item]>`; the empty case is `.loaded([])` and is the view's job to present.
- Equality ignores the error payload (any `.error` equals any other `.error`); do not rely on `==` to detect a *different* error, and note that changing from one error to another does not trigger an `onChange(of:)`.
- Reset to `.none` when the context changes (different id, logout) so stale data is not shown for the wrong subject.
- Do not assume app-level helpers such as `isNone`, `isError` or a `retry:` overload exist in the package — they are not part of it. Add them in the app if wanted.

- For the no-content case write the explicit type `AsyncLoadNoContent`.
- `AsyncLoad` is `Sendable`; the views are SwiftUI-only (`#if canImport(SwiftUI)`).

See `references/patterns.md` for a view model example, composite screens and testing.
