//
//  TraceEntity+CoreDataClass.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//
//

import Foundation
import CoreData

@objc(TraceEntity)
public class TraceEntity: NSManagedObject {
    
    @NSManaged public var title: String
    @NSManaged public var content: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TraceEntity> {
        return NSFetchRequest<TraceEntity>(entityName: "TraceEntity")
    }
    
    func toDomain() -> Trace {
        return .init(title: title, content: content)
    }
    
}

extension TraceEntity {
    convenience init(trace: Trace, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        title = trace.title
        content = trace.content
    }
}
