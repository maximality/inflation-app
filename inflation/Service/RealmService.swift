//
//  RealmService.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import RealmSwift

final class RealmService {
    private lazy var configuration = Realm.Configuration(
        schemaVersion: 4,
        migrationBlock: { migration, oldSchemaVersion in
            //do nothing
    })
    
    var realm: Realm {
        return try! Realm(configuration: configuration)
    }
    
    
}
