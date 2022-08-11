//
//  Task.swift
//  ToDoDemo
//
//  Created by Stanly Shiyanovskiy on 11.08.2022.
//

import Foundation
import RealmSwift

final class Task: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var completed = false
}
