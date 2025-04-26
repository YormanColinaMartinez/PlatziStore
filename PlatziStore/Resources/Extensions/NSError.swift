//
//  NSError.swift
//  PlatziStore
//
//  Created by mac on 25/04/25.
//

import Foundation
import CoreData

extension NSError {
    var detailedErrors: [Error]? {
        if let multipleErrors = userInfo[NSDetailedErrorsKey] as? [Error] {
            return multipleErrors
        } else {
            return [self]
        }
    }
}
