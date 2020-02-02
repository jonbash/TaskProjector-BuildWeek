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
            return try Realm()
        } catch {
            NSLog("Error initializing Realm: \(error)")
            return nil
        }
    }()

    // MARK: - Public Methods

    func fetch<T: Object>(
        _ objectType: T.Type,
        withPredicate predicateString: String,
        in realm: Realm = RealmController.mainRealm
    ) -> Results<T> {
        realm.objects(T.self).filter(predicateString)
    }

    func add<T: Object>(
        _ object: T,
        in realm: Realm = RealmController.mainRealm
    ) throws {
        try realm.write {
            realm.add(object)
        }
    }

    func performUpdates(
        in realm: Realm = RealmController.mainRealm,
        _ updates: @escaping () -> Void
    ) throws {
        try realm.write {
            updates()
        }
    }

    func delete<T: Object>(
        _ object: T,
        in realm: Realm = RealmController.mainRealm
    ) throws {
        try realm.write {
            realm.delete(object)
        }
    }
}
