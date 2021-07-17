//
//  NerworkAndResponseTests.swift
//  NASAMeteorsRecordTests
//
//  Created by Ankush Kushwaha on 7/17/21.
//

import XCTest

class NerworkAndResponseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEndpoint() throws {

        XCTAssert(NetworkService().urlString == "https://data.nasa.gov/resource/y77d-th95.json",
                  "Url is incorrect")
    }
    
    func testBackendJsonStructureAndParsing() throws {

        let exp = expectation(description: "\(#function)\(#line)")

        var meteorModels: [MeteorModel] = []

        NetworkService().fetchMeteorsData { (meteorModelArray, error) in

            meteorModels = meteorModelArray ?? []

            exp.fulfill()

//            XCTFail("Json from Backend is not being parsed to models")

        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert(meteorModels.count > 0, "Json from Backend is not being parsed to models")
    }


}
