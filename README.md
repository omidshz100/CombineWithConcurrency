markdown
# Swift Concurrency with Async/Await and Grand Central Dispatch

This repository demonstrates various concepts of **Swift Concurrency** using **async/await**, **SwiftUI**, **actors**, and **Grand Central Dispatch** (GCD). The examples cover how to work with asynchronous tasks, bridge completion handlers into async functions, and manage concurrent operations using GCD and actors.

## Concepts Covered

### Swift Concurrency with Async/Await

#### Calling Async Functions from Other Async Functions
- Async functions can be called from other async functions using the `await` keyword.

Example:
```swift
func loadCount() async -> Int {
    // Simulate delay
    return 42
}

func load() async {
    let result = await loadCount()  // Calling an async function
}


#### Calling Async Functions from Synchronous Functions
- We can call an async function from a synchronous function by using `Task` to create an asynchronous context.

Example:
```swift
func someSynchronousFunction() {
    Task {
        let result = await loadCount()  // Calling async function in a Task
        print("Result: \(result)")
    }
}
```

#### Running an Asynchronous Task When a SwiftUI View Appears
- Use the `.task(priority:_:)` modifier to start an asynchronous task when a SwiftUI view appears.

Example:
```swift
var body: some View {
    Text(viewModel.status)
        .task {
            await viewModel.refreshStatus()  // Running async task on view appear
        }
}
```

#### Bridging Completion Handlers into Async Functions
- You can bridge a completion handler-based function into an async function using `withCheckedContinuation`. This function allows you to suspend the execution until the completion handler provides a result.

Example:
```swift
private func fetchData(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
        completion("Data fetched from legacy API")
    }
}

private func fetchDataAsync() async -> String {
    await withCheckedContinuation { continuation in
        fetchData { result in
            continuation.resume(returning: result)
        }
    }
}
```

#### What Are Swift Actors?
- Swift actors are reference types used for data synchronization. They prevent data races by isolating mutable data and ensuring that only one task can modify it at a time.

Example:
```swift
actor Counter {
    private var value = 0

    func increment() {
        value += 1
    }

    func getValue() -> Int {
        return value
    }
}
```

---

### Grand Central Dispatch & Operations

#### Grand Central Dispatch (GCD)
- GCD provides a high-level API for managing concurrent tasks. It is built on top of threads and can be used to execute blocks of code on dispatch queues. While GCD is still widely used, Swift's async/await is making it increasingly obsolete for many use cases.

#### Dispatch Queues: Serial vs Concurrent
- **Serial Queues** execute tasks one at a time, in the order they are added. This guarantees that tasks do not overlap.
- **Concurrent Queues** allow multiple tasks to run simultaneously.

Example:
```swift
let serialQueue = DispatchQueue(label: "serialQueue")
let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
```

#### Main vs Global Dispatch Queues
- The **main queue** runs on the main thread and is serial. It is typically used for UI updates.
- **Global queues** are concurrent queues that are shared by the system with different quality-of-service (QoS) levels.

Example:
```swift
DispatchQueue.global(qos: .default).async {
    let text = loadDescription()
    DispatchQueue.main.async {
        label.text = text
    }
}
```

---

## Example Code: `Sample7_1_3.swift`

This file demonstrates how to use **Swift actors**, **async/await**, and **completion handler bridging** in a simple SwiftUI app.

```swift
import Foundation
import SwiftUI

actor Counter {
    private var value = 0

    func increment() {
        value += 1
    }

    func getValue() -> Int {
        return value
    }
}

class ViewModel: ObservableObject {
    @Published var status: String = "Loading..."
    @Published var incomingData: String = "Loading..."
    @Published var counterValue: Int = 0

    private let counter = Counter()

    func incrementCounter() async {
        await counter.increment()
        let newValue = await counter.getValue()

        await MainActor.run {
            self.counterValue = newValue
        }
    }

    func loadCount() async -> Int {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)  // Simulate delay
        return 42
    }

    enum DataError: Error {
        case failedToLoad
    }

    func loadData() async throws -> String {
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Simulate delay
        if Bool.random() {
            return "Successfully loaded data!"
        } else {
            throw DataError.failedToLoad
        }
    }

    func someSynchronousFunction() {
        Task {
            let result = await loadCount()
            print("Result: \(result)")
        }
    }

    func someSynchronousFunctionWithErrorHandling() {
        Task {
            do {
                let result = try await loadData()
                print("Data: \(result)")
            } catch {
                print("Error occurred: \(error)")
            }
        }
    }

    func refreshStatus() async {
        do {
            try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
            await MainActor.run {
                self.status = "Data loaded successfully!"
            }
        } catch {
            await MainActor.run {
                self.status = "Failed to load data."
            }
        }
    }

    private func fetchData(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion("Data fetched from legacy API")
        }
    }

    private func fetchDataAsync() async -> String {
        await withCheckedContinuation { continuation in
            fetchData { result in
                continuation.resume(returning: result)
            }
        }
    }

    func loadIncommingData() async {
        let result = await fetchDataAsync()
        await MainActor.run {
            self.incomingData = result
        }
    }
}
```

---

## Conclusion

This project demonstrates how to effectively work with **Swift Concurrency** using **async/await**, **actors**, and **completion handler bridging**. It also covers the use of **Grand Central Dispatch (GCD)** for managing concurrency with serial and concurrent queues.

By understanding these concepts, you can write more efficient and readable concurrent code in Swift, while leveraging modern tools like Swift actors and async/await to handle complex concurrency scenarios.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```
