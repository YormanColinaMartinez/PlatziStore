//
//  Persistence.swift
//  PlatziStore
//
//  Created by mac on 2/04/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Error en Preview: \(error.localizedDescription)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PlatziStore")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error cargando Core Data: \(error.userInfo)")
            }
        }
    }
    
    func saveProductToCoreData(from productResponse: ProductResponse, context: NSManagedObjectContext) {
        let product = Product(context: context)
        product.id = productResponse.id
        product.title = productResponse.title
        product.price = productResponse.price
        product.slug = productResponse.category.slug
        product.productDescription = productResponse.productDescription

        for url in productResponse.images {
            let productImage = ProductImage(context: context)
            productImage.url = url
            productImage.productRelationship = product
        }

        do {
            try context.save()
        } catch {
            print("Error al guardar producto: \(error)")
        }
    }
}
