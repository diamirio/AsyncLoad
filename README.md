# AsyncLoad

A Swift package that provides elegant state management for asynchronous operations in iOS, macOS, watchOS, and visionOS applications.

## Overview

AsyncLoad provides components for handling asynchronous operations:
- `AsyncLoad<T>`: For loading data operations
- `AsyncAction<T>`: For action-based operations
- `CachedAsyncLoad<T>`: For loading operations that preserve cached data during refreshes
- `CachedAsyncAction<T>`: For actions that preserve cached data during retries
- `AsyncLoadView`: A SwiftUI view component for displaying async states
- `CachedAsyncLoadView`: A SwiftUI view component for cached async states

## Requirements

- iOS 16.0+
- macOS 13.0+
- watchOS 9.0+
- visionOS 1.0+
- Swift 6.1+

## Installation

### Swift Package Manager

Add AsyncLoad to your project by adding the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/diamirio/AsyncLoad", from: "2.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

## Components

### AsyncLoad<T>

An enum that represents the state of an asynchronous data loading operation.

```swift
public enum AsyncLoad<T>: Equatable {
    case none        // Initial state
    case loading     // Loading in progress
    case error(Error)// Loading failed with error
    case loaded(T)   // Successfully loaded with data
}
```

#### Properties

- `isLoading: Bool` - Returns true if the state is `.loading`
- `item: T?` - Returns the loaded item if state is `.loaded`, nil otherwise
- `error: Error?` - Returns the error if state is `.error`, nil otherwise

#### Example Usage

```swift
import AsyncLoad

@Observable
class DataViewModel {
    var userProfile: AsyncLoad<User> = .none
    
    func loadUserProfile(id: String) async {
        userProfile = .loading
        
        do {
            let user = try await userService.fetchUser(id: id)
            userProfile = .loaded(user)
        } catch {
            userProfile = .error(error)
        }
    }
}
```

### AsyncAction<T>

Similar to AsyncLoad but designed for action-based operations (like posting data, submitting forms, etc.).

```swift
public enum AsyncAction<T>: Equatable {
    case none         // Initial state
    case loading      // Action in progress
    case error(Error) // Action failed with error
    case success(T)   // Action completed successfully
}
```

#### Properties

- `isLoading: Bool` - Returns true if the state is `.loading`
- `item: T?` - Returns the success result if state is `.success`, nil otherwise
- `error: Error?` - Returns the error if state is `.error`, nil otherwise

#### Example Usage

```swift
import AsyncLoad

@Observable
class FormViewModel {
    var submitAction: AsyncAction<SubmitResponse> = .none
    
    func submitForm(data: FormData) async {
        submitAction = .loading
        
        do {
            let response = try await apiService.submit(data)
            submitAction = .success(response)
        } catch {
            submitAction = .error(error)
        }
    }
}
```

### CachedAsyncLoad<T>

An enhanced version of AsyncLoad that preserves cached data during loading and error states.

```swift
public enum CachedAsyncLoad<T>: Equatable {
    case none                    // Initial state
    case loading(T? = nil)       // Loading with optional cached data
    case error(T? = nil, Error)  // Error with optional cached data
    case loaded(T)               // Successfully loaded with data
}
```

#### Properties

- `isLoading: Bool` - Returns true if the state is `.loading`
- `item: T?` - Returns the item from `.loaded`, `.loading`, or `.error` states, nil for `.none`
- `error: Error?` - Returns the error if state is `.error`, nil otherwise

#### Example Usage

```swift
import AsyncLoad

@Observable
class CachedDataViewModel {
    var userProfile: CachedAsyncLoad<User> = .none

    func loadUserProfile(id: String) async {
        // Start loading while preserving any existing data
        if case .loaded(let existingUser) = userProfile {
            userProfile = .loading(existingUser)
        } else {
            userProfile = .loading()
        }

        do {
            let user = try await userService.fetchUser(id: id)
            userProfile = .loaded(user)
        } catch {
            // Preserve existing data even during error
            let existingUser = userProfile.item
            userProfile = .error(existingUser, error)
        }
    }
}
```

### CachedAsyncAction<T>

Similar to AsyncAction but preserves cached data during loading and error states.

```swift
public enum CachedAsyncAction<T>: Equatable {
    case none                    // Initial state
    case loading(T? = nil)       // Action in progress with optional cached data
    case error(T? = nil, Error)  // Action failed with optional cached data
    case success(T)              // Action completed successfully
}
```

#### Properties

- `isLoading: Bool` - Returns true if the state is `.loading`
- `item: T?` - Returns the success result if state is `.success`, nil otherwise
- `error: Error?` - Returns the error if state is `.error`, nil otherwise

#### Example Usage

```swift
import AsyncLoad

@Observable
class CachedFormViewModel {
    var submitAction: CachedAsyncAction<SubmitResponse> = .none

    func submitForm(data: FormData) async {
        // Preserve previous successful response during retry
        if case .success(let previousResponse) = submitAction {
            submitAction = .loading(previousResponse)
        } else {
            submitAction = .loading()
        }

        do {
            let response = try await apiService.submit(data)
            submitAction = .success(response)
        } catch {
            let previousResponse = submitAction.item
            submitAction = .error(previousResponse, error)
        }
    }
}
```

### AsyncLoadView

A SwiftUI view component that automatically handles the display of different async states.

```swift
public struct AsyncLoadView<Item, Content: View, ErrorContent: View>: View
```

#### Initializers

```swift
// With custom error content
public init(
    _ state: AsyncLoad<Item>,
    @ViewBuilder content: @escaping (Item?) -> Content,
    @ViewBuilder error: @escaping (Error) -> ErrorContent
)

// With default error content (Text)
public init(
    _ state: AsyncLoad<Item>,
    @ViewBuilder content: @escaping (Item?) -> Content
) where ErrorContent == Text
```

#### Example Usage

```swift
import SwiftUI
import AsyncLoad

struct UserProfileView: View {
    @State private var viewModel = UserProfileViewModel()

    var body: some View {
        AsyncLoadView(viewModel.userProfile) { user in
            if let user = user {
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.title)
                    Text(user.email)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("No user data")
            }
        } error: { error in
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                Text("Failed to load user: \(error.localizedDescription)")
                    .multilineTextAlignment(.center)
            }
        }
        .task {
            await viewModel.loadUserProfile(id: "123")
        }
    }
}
```

### CachedAsyncLoadView

A SwiftUI view component that handles cached async states with separate loading content.

```swift
public struct CachedAsyncLoadView<Item, Content: View, ErrorContent: View, LoadingContent: View>: View
```

#### Initializer

```swift
public init(
    _ state: CachedAsyncLoad<Item>,
    @ViewBuilder content: @escaping (Item) -> Content,
    @ViewBuilder loading: @escaping (Item?) -> LoadingContent,
    @ViewBuilder error: @escaping (Item?, Error) -> ErrorContent
)
```

#### Example Usage

```swift
import SwiftUI
import AsyncLoad

struct CachedUserProfileView: View {
    @State private var viewModel = CachedUserProfileViewModel()

    var body: some View {
        CachedAsyncLoadView(viewModel.userProfile) { user in
            // Content view - only called when data is loaded
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title)
                Text(user.email)
                    .foregroundStyle(.secondary)
            }
        } loading: { cachedUser in
            // Loading view - receives cached data if available
            VStack {
                if let cachedUser {
                    VStack(alignment: .leading) {
                        Text(cachedUser.name)
                            .font(.title)
                        Text(cachedUser.email)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(0.5)
                }
                ProgressView()
            }
        } error: { cachedUser, error in
            // Error view - receives cached data if available
            VStack {
                if let cachedUser {
                    VStack(alignment: .leading) {
                        Text(cachedUser.name)
                            .font(.title)
                        Text(cachedUser.email)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(0.5)
                }
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
        .task {
            await viewModel.loadUserProfile(id: "123")
        }
    }
}
```

## Features

- **Type-safe**: Generic enums ensure type safety for your data
- **Equatable**: All async state enums conform to Equatable for easy state comparison
- **SwiftUI Integration**: AsyncLoadView and CachedAsyncLoadView provide seamless integration with SwiftUI
- **Error Handling**: Built-in error state management
- **Loading States**: Automatic loading state handling with progress indicators
- **Cached Data**: CachedAsyncLoad and CachedAsyncAction preserve data during refreshes and errors
- **Flexible UI**: Customizable content and error views

## Best Practices

1. **Use AsyncLoad for data fetching** operations (GET requests, loading content)
2. **Use AsyncAction for user actions** (POST/PUT/DELETE requests, form submissions)
3. **Use CachedAsyncLoad** when you want to preserve data during refreshes or show stale data during errors
4. **Use CachedAsyncAction** when you want to preserve previous results during action retries
5. **Always handle all states** in your UI to provide good user experience
6. **Use AsyncLoadView and CachedAsyncLoadView** for simple cases to reduce boilerplate code
7. **Reset states** appropriately (e.g., set to `.none` when appropriate)
