//
//  TaskRow.swift
//  ToDoDemo
//
//  Created by Stanly Shiyanovskiy on 10.08.2022.
//

import SwiftUI

struct TaskRow: View {
    
    let task: String
    let completed: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: completed ? "checkmark.circle" : "circle")
            
            Text(task)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: "Do laundry", completed: true)
    }
}
