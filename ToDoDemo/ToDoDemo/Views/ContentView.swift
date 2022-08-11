//
//  ContentView.swift
//  ToDoDemo
//
//  Created by Stanly Shiyanovskiy on 10.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var realManager = RealmManager()
    @State private var showAddTaskView = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TasksView()
                .environmentObject(realManager)
            
            SmallAddButton()
                .padding()
                .onTapGesture {
                    showAddTaskView.toggle()
                }
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView()
                .environmentObject(realManager)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(
            Color(hue: 0.086, saturation: 0.141, brightness: 0.972)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
