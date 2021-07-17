//
//  NASAMeteorsRecordTests.swift
//  NASAMeteorsRecordTests
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import XCTest
@testable import NASAMeteorsRecord


class NASAMeteorsModelPasringTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONParsing() throws {
        guard let firstMeteor = MockData().getModels()?.first else {

            XCTFail("No mock data available")

            return
        }

        XCTAssertEqual(firstMeteor.name, "Aachen")
        XCTAssertEqual(firstMeteor.mass, "21")

    }

    func testMeteorViewModel() throws {

        guard let firstMeteor = MockData().getModels()?.first else {

            XCTFail("No mock data available")

            return
        }

        let viewModel = MeteorViewModel(model: firstMeteor)

        XCTAssertEqual(viewModel.name, "Aachen")
        XCTAssertEqual(viewModel.mass, "21")
        XCTAssertEqual(viewModel.year, "1.1.1880")

    }

}



