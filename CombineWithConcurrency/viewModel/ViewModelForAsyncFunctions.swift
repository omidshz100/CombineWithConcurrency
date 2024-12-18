//
//  Sample7_1_3.swift
//  CombineWithConcurrency
//
//  Created by Omid Shojaeian Zanjani on 18/12/24.
//

import Foundation
import SwiftUI
// init

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
    
    
    // Shared Counter actor instance
        private let counter = Counter()
    // Increment the counter and update the UI
       func incrementCounter() async {
           await counter.increment() // Call actor method
           let newValue = await counter.getValue()
           
           // Update the UI on the main thread
           await MainActor.run {
               self.counterValue = newValue
           }
       }
    
    
    
    
    // Async function that does not throw
    func loadCount() async -> Int {
        // Simulate a delay
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second
        return 42
    }

    // Async function that throws
    enum DataError: Error {
        case failedToLoad
    }

    func loadData() async throws -> String {
        // Simulate a delay
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 1 second
        // Simulate success or failure
        if Bool.random() {
            return "Successfully loaded data!"
        } else {
            throw DataError.failedToLoad
        }
    }

    // Synchronous function calling a non-throwing async function
    func someSynchronousFunction() {
        print("Calling async function from synchronous function...")
        Task {
            let result = await loadCount()
            print("Result: \(result)")
        }
    }

    // Synchronous function calling a throwing async function
    func someSynchronousFunctionWithErrorHandling() {
        print("Calling async throws function from synchronous function...")
        Task {
            do {
                let result = try await loadData()
                print("Data: \(result)")
            } catch {
                print("Error occurred: \(error)")
            }
        }
    }
    
    
    // Async function to simulate data fetching
    func refreshStatus() async {
        do {
            try await Task.sleep(nanoseconds: 5 * 1_000_000_000) // Simulate a 2-second delay
            // Update status with new data
            await MainActor.run {
                self.status = "Data loaded successfully!"
            }
        } catch {
            // Handle error (if any)
            await MainActor.run {
                self.status = "Failed to load data."
            }
        }
    }
    
    
    
    /// The way  bridge a completion-handler-based API into Swift’s async/await system
    /// we haev this completion function
    
   private func fetchData(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion("Data fetched from legacy API")
        }
    }
    
    // then here ew bridge to the await/async
    // Bridging the completion handler into an async function
   private func fetchDataAsync() async -> String {
        await withCheckedContinuation { continuation in
            fetchData { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func loadIncommingData() async {
       // Use the bridged async function
       let result = await fetchDataAsync()
       await MainActor.run {
           // waiting until done this part ... 
           self.incomingData = result
       }
   }
}
