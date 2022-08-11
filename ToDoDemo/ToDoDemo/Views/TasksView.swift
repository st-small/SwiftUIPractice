//
//  TasksView.swift
//  ToDoDemo
//
//  Created by Stanly Shiyanovskiy on 10.08.2022.
//

import SwiftUI

struct TasksView: View {
    
    @EnvironmentObject var realManager: RealmManager
    
    var body: some View {
        VStack {
            Text("My tasks")
                .font(.title3).bold()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                ForEach(realManager.tasks, id: \.id) { task in
                    if !task.isInvalidated {
                        TaskRow(task: task.title, completed: task.completed)
                            .onTapGesture {
                                realManager.updateTask(id: task.id, completed: !task.completed)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    realManager.deleteTask(id: task.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                            }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(hue: 0.086, saturation: 0.141, brightness: 0.972)
        )
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
            .environmentObject(RealmManager())
    }
}
