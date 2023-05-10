//
//  FavoriteRadio+CoreDataProperties.swift
//  AVRadio
//
//  Created by Artemy Volkov on 10.05.2023.
//
//

import Foundation
import CoreData


extension FavoriteRadio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRadio> {
        return NSFetchRequest<FavoriteRadio>(entityName: "FavoriteRadio")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var favicon: String?

}

extension FavoriteRadio : Identifiable {

}
