//
//  Order.swift
//  PlatziStore
//
//  Created by mac on 29/05/25.
//

import Foundation
import CoreData

extension Order {
    var itemsArray: [OrderItem] {
        let set = itemsRelationship as? Set<OrderItem> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
}
