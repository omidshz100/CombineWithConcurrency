# Swift Concurrency with Async/Await and Grand Central Dispatch

This repository demonstrates key concepts of **Swift Concurrency** and **Grand Central Dispatch (GCD)**, focusing on how to use **async/await**, **SwiftUI**, and **actors** to handle asynchronous tasks and concurrency in Swift.

## Concepts Covered

### Swift Concurrency with Async/Await

- **Calling Async Functions from Other Async Functions**  
  You can call an async function from another async function by using the `await` keyword.

- **Calling Async Functions from Synchronous Functions**  
  You can call an async function from a synchronous function using the `Task` struct to create an asynchronous context.

- **Running an Asynchronous Task When a SwiftUI View Appears**  
  Use the `.task(priority:_:)` modifier in SwiftUI to start an asynchronous task right before the view appears on screen.

- **Bridging Completion Handlers into Async Functions**  
  To bridge a legacy completion handler function into Swift's async/await system, you can use the `withCheckedContinuation` function, which allows you to suspend the function until the completion handler provides a result.

- **Swift Actors**  
  Swift actors are used to handle concurrency by isolating mutable data and ensuring that only one task can access or modify the data at a time, preventing data races.

---

### Grand Central Dispatch (GCD)

- **What is GCD?**  
  GCD is a low-level API that provides a way to manage concurrent tasks using dispatch queues. It is still widely used, though with the advent of Swift's async/await, some use cases are now simpler to handle with async/await.

- **Dispatch Queues: Serial vs Concurrent**  
  Serial queues execute tasks one at a time in the order they are added, while concurrent queues allow multiple tasks to run simultaneously.

- **Main vs Global Dispatch Queues**  
  The main queue is a serial queue used for updating the UI, while global queues are concurrent queues shared by the system, offering different quality-of-service (QoS) levels for tasks.

---

## Conclusion

This project illustrates how to use **Swift Concurrency** to write efficient and readable concurrent code using **async/await** and **actors**, and also demonstrates how to manage concurrency with **Grand Central Dispatch**. Understanding these tools is essential for handling asynchronous tasks and preventing issues like data races in modern Swift applications.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
