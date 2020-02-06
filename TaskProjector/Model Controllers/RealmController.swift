//
//  RealmController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift


class RealmController {

    private static var mainRealm: Realm! = {
        do {
            /* `schemaVersion`s :
             0: init
             1: add Task.createdDate
             2: try some non-private Strings
             3: primary keys added to Area, Tag
             */
            let config = Realm.Configuration(
                schemaVersion: 3,
                migrationBlock: { _, oldSchemaVersion in
                    if oldSchemaVersion < 1 {
                        return
                    }
            })
            return try Realm(configuration: config)
        } catch {
            NSLog("Error initializing Realm: \(error)")
            return nil
        }
    }()

    private static var usingRealm: Realm?

    private var _realm: Realm?
    private var realm: Realm {
        _realm ?? RealmController.mainRealm
    }

    init(_ realm: Realm? = nil) {
        RealmController.usingRealm = realm
    }

    // MARK: - Public Methods

    func fetch<T: Object>(
        _ model: T.Type,
        fromContext realm: Realm = usingRealm ?? mainRealm,
        predicate: NSPredicate? = nil,
        sorting: Sorting? = nil
    ) throws -> Results<T> {
        var results = realm.objects(model.self)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        if let sorting = sorting {
            results = results.sorted(byKeyPath: sorting.key,
                                     ascending: sorting.ascending)
        }
        return results
    }

    func save(
        _ object: Object,
        inContext realm: Realm = usingRealm ?? mainRealm
    ) throws {
        try realm.write { realm.add(object, update: .all) }
    }

    func saveObjects(
        _ objects: [Object],
        inContext realm: Realm = usingRealm ?? mainRealm
    ) throws {
        try realm.write { realm.add(objects) }
    }

    func performUpdates(
        inContext realm: Realm = usingRealm ?? mainRealm,
        _ updates: () throws -> Void
    ) throws {
        try realm.write(updates)
    }

    func delete(
        _ object: Object,
        inContext realm: Realm = usingRealm ?? mainRealm
    ) throws {
        try realm.write { realm.delete(object) }
    }

    func deleteAll<T: Object>(
        _ model: T.Type,
        inContext realm: Realm = usingRealm ?? mainRealm
    ) throws {
        try realm.write {
            let objects = realm.objects(model.self)
            for object in objects {
                realm.delete(object)
            }
        }
    }
}
