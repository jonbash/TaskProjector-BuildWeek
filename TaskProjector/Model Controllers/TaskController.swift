//
//  TaskController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift

class TaskController {
    lazy var realm: Realm! = {
        do {
            return try Realm()
        } catch {
            NSLog("Error initializing Realm: \(error)")
            return nil
        }
    }()

    lazy var topLevelTasks: Results<Task> = {
        realm.objects(Task.self).filter(
            NSPredicate(format: "parentArea = nil AND parentProject = nil"))
    }()
    lazy var topLevelAreas: Results<Area> = {
        realm.objects(Area.self).filter(
            NSPredicate(format: "parent = nil"))
    }()
    lazy var topLevelTags: Results<Tag> = {
        realm.objects(Tag.self).filter(NSPredicate(format: "parent = nil"))
    }()
}
