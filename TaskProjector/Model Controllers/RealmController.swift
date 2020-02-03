//
//  RealmController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - Protocol Conformance

extension Object: Persistable {}

extension Realm: PersistentContext {}


class RealmController: PersistenceController {

    private static var mainRealm: Realm! = {
        do {
            return try Realm()
        } catch {
            NSLog("Error initializing Realm: \(error)")
            return nil
        }
    }()

    init() {}

    // MARK: - Public Methods

    func create<T: Persistable>(
        _ model: T.Type,
        inContext context: PersistentContext
    ) throws -> T {
        let realm = try realmFromContext(context)
        realm.beginWrite()
        guard
            let model = model as? Object.Type,
            let newObject = realm.create(model, value: [], update: .error) as? T
            else { throw Realm.Error(.fail) }
        try realm.commitWrite()
        return newObject
    }

    func fetch<T: Persistable, TC: Collection>(
        _ model: T.Type,
        expectingCollectionType collectionType: TC.Type,
        fromContext context: PersistentContext,
        predicate: NSPredicate? = nil,
        sorting: Sorting? = nil
    ) throws -> TC {
        let realm = try realmFromContext(context)
        let objectType = try modelAsObject(model)

        var results = realm.objects(objectType)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        if let sorting = sorting {
            results = results.sorted(byKeyPath: sorting.key,
                                     ascending: sorting.ascending)
        }

        guard let output = results as? TC else {
            throw Realm.Error(.fail)
        }
        return output
    }

    func save(
        _ persistable: Persistable,
        inContext context: PersistentContext
    ) throws {
        let realm = try realmFromContext(context)
        let object = try objectFromPersistable(persistable)
        try realm.write {
            realm.add(object)
        }
    }

    func performUpdates(
        inContext context: PersistentContext,
        _ updates: () throws -> Void
    ) throws {
        let realm = try realmFromContext(context)
        try realm.write(updates)
    }

    func delete(
        _ persistable: Persistable,
        inContext context: PersistentContext
    ) throws {
        let realm = try realmFromContext(context)
        let object = try objectFromPersistable(persistable)
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll<T>(
        _ model: T.Type,
        inContext context: PersistentContext
    ) throws where T: Persistable {
        let modelType = try modelAsObject(model)
        let realm = try realmFromContext(context)
        try realm.write {
            let objects = realm.objects(modelType)
            for object in objects {
                realm.delete(object)
            }
        }
    }

    // MARK: - Using Default Realm

    func create<T: Persistable>(_ model: T.Type) throws -> T {
        try create(model, inContext: RealmController.mainRealm)
    }

    func fetch<T: Persistable, TC: Collection>(
        _ model: T.Type,
        expectingCollectionType collectionType: TC.Type,
        predicate: NSPredicate? = nil,
        sorting: Sorting? = nil
    ) throws -> TC {
        try fetch(model,
                  expectingCollectionType: collectionType,
                  fromContext: RealmController.mainRealm,
                  predicate: predicate,
                  sorting: sorting)
    }

    func save(_ persistable: Persistable) throws {
        try save(persistable, inContext: RealmController.mainRealm)
    }

    func performUpdates(_ updates: @escaping () throws -> Void) throws {
        try performUpdates(inContext: RealmController.mainRealm, updates)
    }

    func delete(_ persistable: Persistable) throws {
        try delete(persistable, inContext: RealmController.mainRealm)
    }

    func deleteAll<T: Persistable>(_ model: T.Type) throws {
        try deleteAll(model, inContext: RealmController.mainRealm)
    }

    // MARK: - Private

    private func realmFromContext(_ context: PersistentContext) throws -> Realm {
        guard let realm = context as? Realm else { throw Realm.Error(.fail) }
        return realm
    }

    private func objectFromPersistable(_ persistable: Persistable) throws -> Object {
        guard let object = persistable as? Object else { throw Realm.Error(.fail) }
        return object
    }

    private func modelAsObject<T: Persistable>(_ model: T.Type) throws -> Object.Type {
        guard let objectType = model as? Object.Type else { throw Realm.Error(.fail) }
        return objectType
    }
}
