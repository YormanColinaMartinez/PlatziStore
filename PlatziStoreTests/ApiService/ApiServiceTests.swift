//
//  ApiServiceTests.swift
//  PlatziStoreTests
//
//  Created by mac on 12/04/25.
//

import XCTest
import CoreData
@testable import PlatziStore

final class ApiServiceTests: XCTestCase {

    struct DummyDTO: Codable, Equatable {
        let id: Int

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
        }

        enum CodingKeys: String, CodingKey {
            case id
        }
    }

    final class DummyEntity {
        var id: Int = 0
    }

    var sut: ApiService!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        let container = NSPersistentContainer(name: "PlatziStore")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        sut = ApiService(session: session)
    }

    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }

    func testFetchEntitiesInvalidUrl() async {
        let url = "ht🤯tp://invalid-url"
        do {
            _ = try await sut.fetchEntities(urlString: url, context: context) { (dto: DummyDTO, _) in dto }
            XCTFail("Se esperaba un error de URL")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("Se esperaba URLError, no \(type(of: error))")
        }
    }

    func testFetchEntitiesNetworkError() async {
        MockURLProtocol.responseError = URLError(.notConnectedToInternet)

        do {
            _ = try await sut.fetchEntities(urlString: "https://fakeapi.com", context: context) { (dto: DummyDTO, _) in dto }
            XCTFail("Se esperaba error de red")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func testFetchEntitiesInvalidJson() async {
        let invalidJSON = """
            [{ "wrongKey": "value" }]
        """
        guard let invalidData = invalidJSON.data(using: .utf8) else {
            XCTFail("Error al convertir JSON a Data")
            return
        }
        MockURLProtocol.stubResponseData = invalidData
        MockURLProtocol.responseError = nil

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)

        let sut = ApiService(session: mockSession)

        let container = NSPersistentContainer(name: "PlatziStore")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        let context = container.viewContext

        do {
            _ = try await sut.fetchEntities(
                urlString: "https://fakeapi.com",
                context: context
            ) { (_: DummyDTO, _) in
                return DummyEntity()
            }
            XCTFail("Se esperaba un error de decodificación")
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, _):
                XCTAssertEqual(key.stringValue, "id")
            default:
                XCTFail("Se esperaba error .keyNotFound, pero fue: \(error)")
            }
        } catch {
            XCTFail("Se esperaba DecodingError, pero fue: \(type(of: error))")
        }
    }

    
    func ttestFetchEntitiesErrorContextSave() async {
        let validJSON = "[{\"id\": 1}]".data(using: .utf8)!
        MockURLProtocol.stubResponseData = validJSON

        let context = FailingSaveContext()

        do {
            _ = try await sut.fetchEntities(urlString: "https://fakeapi.com", context: context) { (dto: DummyDTO, _) in dto }
            XCTFail("Se esperaba error al guardar contexto")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Save failed")
        }
    }

    func testFetchEntitiesSuccess() async throws {
        let validJSON = "[{\"id\": 1}, {\"id\": 2}]".data(using: .utf8)!
        MockURLProtocol.stubResponseData = validJSON

        let result = try await sut.fetchEntities(urlString: "https://fakeapi.com", context: context) { (dto: DummyDTO, _) in
            return dto.id
        }

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], 1)
    }
    
    func testFetchEntitiesEmptyResponse() async throws {
        let emptyJSON = "[]".data(using: .utf8)!
        MockURLProtocol.stubResponseData = emptyJSON

        let result = try await sut.fetchEntities(
            urlString: "https://fakeapi.com",
            context: context
        ) { (dto: DummyDTO, _) in dto.id }

        XCTAssertTrue(result.isEmpty, "Se esperaba array vacío")
    }
}
