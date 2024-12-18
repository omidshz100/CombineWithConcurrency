//
//  ViewModel.swift
//  CombineWithConcurrency
//
//  Created by Omid Shojaeian Zanjani on 18/12/24.
//

import Foundation
import SwiftUI

class ViewModelQueueSample: ObservableObject {
    @Published var status: String = "Waiting (ViewModelQueueSample)..."
    
    // Serial Queue: Tasks are executed one after the other.
    private let serialQueue = DispatchQueue(label: "com.example.serialQueue")
    
    // Concurrent Queue: Tasks are executed simultaneously.
    private let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
    
    // Function to simulate a task on a serial queue
    func performSerialTask() {
        serialQueue.async {
            // Simulating a task that takes 2 seconds
            DispatchQueue.main.async {
                self.status = "Serial Task 1 started"
            }
            Thread.sleep(forTimeInterval: 2)
            DispatchQueue.main.async {
                self.status = "Serial Task 1 finished"
            }
            
            // Another task in the serial queue
            DispatchQueue.main.async {
                self.status = "Serial Task 2 started"
            }
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.status = "Serial Task 2 finished"
            }
        }
    }
    
    // Function to simulate a task on a concurrent queue
    func performConcurrentTask() {
        concurrentQueue.async {
            // Simulating a task that takes 2 seconds
            DispatchQueue.main.async {
                self.status = "Concurrent Task 1 started"
            }
            Thread.sleep(forTimeInterval: 2)
            DispatchQueue.main.async {
                self.status = "Concurrent Task 1 finished"
            }
        }
        
        concurrentQueue.async {
            // Simulating a task that takes 1 second
            DispatchQueue.main.async {
                self.status = "Concurrent Task 2 started"
            }
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.status = "Concurrent Task 2 finished"
            }
        }
    }
}
