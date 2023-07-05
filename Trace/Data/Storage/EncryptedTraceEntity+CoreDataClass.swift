//
//  EncryptedTraceEntity.swift
//  Trace
//
//  Created by Horus on 2023/07/02.
//

import Foundation
import CoreData

enum EncryptedTraceEntityError: Error {
    case cannotConvertToDomain
    case cannotInitializeEncryptedTraceEntity
}

@objc(EncryptedTraceEntity)
public class EncryptedTraceEntity: NSManagedObject {
    
    @NSManaged public var encryptedTrace: Data
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EncryptedTraceEntity> {
        return NSFetchRequest<EncryptedTraceEntity>(entityName: "EncryptedTraceEntity")
    }
    
}

extension EncryptedTraceEntity {
    convenience init(encryptedData: Data, insertInto context: NSManagedObjectContext) throws {
        self.init(context: context)
        do {
            encryptedTrace = encryptedData
            try context.save()
        } catch {
            throw EncryptedTraceEntityError.cannotInitializeEncryptedTraceEntity
        }
    }
}
