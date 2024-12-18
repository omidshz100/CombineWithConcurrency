//
//  ViewModeel3.swift
//  CombineWithConcurrency
//
//  Created by Omid Shojaeian Zanjani on 18/12/24.
//

import Foundation
import SwiftUI

class ViewModelMain_And_GlobalQueue: ObservableObject {
    @Published var status: String = "Waiting (main and global queue )..."
    
    // Function to simulate background work and UI update
    func loadData() {
        // Use the global queue for background work
        DispatchQueue.global(qos: .background).async {
            // Simulating data fetching that takes time (2 seconds)
            Thread.sleep(forTimeInterval: 2)
            let fetchedData = "Data fetched from background task"
            
            // Use the main queue to update the UI
            DispatchQueue.main.async {
                self.status = fetchedData
            }
        }
    }
}
