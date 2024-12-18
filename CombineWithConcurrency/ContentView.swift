//
//  ContentView.swift
//  CombineWithConcurrency
//
//  Created by Omid Shojaeian Zanjani on 18/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @StateObject private var viewModel2 = ViewModelQueueSample()
    @StateObject private var viewModelMainAndGlobal = ViewModelMain_And_GlobalQueue()
    
    
    @State var data = " Data is comming .... "
    @State var data2 = " Data is on way, plesee wait ... "
    
    var body: some View {
        ScrollView{
            VStack {
                Text("-------------------------------------")
                Text("Showing the result after 5 seconds")
                Text("\(viewModel.status)")
                    .padding()
                Text("Showing the result after 6 seconds")
                Text("\(viewModel.incomingData)")
                    .padding()
                
                Text("Counter Value: \(viewModel.counterValue)")
                                .font(.headline)
                
                
                Text("-------------------------------------")
                Text(viewModel2.status)
                                .font(.headline)
                                .padding()
                            
                            HStack {
                                Button("Run Serial Tasks") {
                                    viewModel2.performSerialTask()
                                }
                                .padding()
                                
                                Button("Run Concurrent Tasks") {
                                    viewModel2.performConcurrentTask()
                                }
                                .padding()
                            }
                Text("-------------------------------------")
                Text(viewModelMainAndGlobal.status)
                                .font(.headline)
                                .padding()
                            
                            Button("Fetch Data") {
                                // Trigger the background task to fetch data
                                viewModelMainAndGlobal.loadData()
                            }
                            .padding()
            }
        }
        .padding()
        .task {
            // here we can run and handle all await functions from viewmodel
            
            // code wait in await part until take action complete then go for the next two line becasuse here they are not await function but inside they have another dedicated await function in this wat the published variable update UI in main thred
            await viewModel.refreshStatus()
            // this part runs after 5 secons
            await viewModel.loadIncommingData()
            // 
            viewModel.someSynchronousFunction()
            viewModel.someSynchronousFunctionWithErrorHandling()
            
            
        }
    }
}

#Preview {
    ContentView()
}
