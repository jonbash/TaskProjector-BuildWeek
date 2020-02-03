//
//  PersistenceController.swift
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-02.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation

protocol PersistenceController {
    func create<T: Persistable>(
        _ model: T.Type,
        inContext context: PersistentContext) throws -> T
    func fetch<T: Persistable, TC: Collection>(
        _ model: T.Type,
        expectingCollectionType collectionType: TC.Type,
        fromContext context: PersistentContext,
        predicate: NSPredicate?,
        sorting: Sorting?) throws -> TC
    func save(
        _ persistable: Persistable,
        inContext context: PersistentContext)throws
    func performUpdates(
        inContext context: PersistentContext,
        _ updates: @escaping () throws -> Void) throws
    func delete(
        _ persistable: Persistable,
        inContext context: PersistentContext) throws
    func deleteAll<T: Persistable>(
        _ model: T.Type,
        inContext context: PersistentContext) throws

    func create<T: Persistable>(_ model: T.Type) throws -> T
    func save(_ persistable: Persistable) throws
    func fetch<T: Persistable, TC: Collection>(
        _ model: T.Type,
        expectingCollectionType collectionType: TC.Type,
        predicate: NSPredicate?,
        sorting: Sorting?) throws -> TC
    func performUpdates(_ updates: @escaping () throws -> Void) throws
    func delete(_ persistable: Persistable) throws
    func deleteAll<T: Persistable>(_ model: T.Type) throws
}

protocol Persistable {}

protocol PersistentContext {}

struct Sorting {
    var key: String
    var ascending: Bool = true
}
