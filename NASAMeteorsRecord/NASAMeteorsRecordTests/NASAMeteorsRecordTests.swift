//
//  NASAMeteorsRecordTests.swift
//  NASAMeteorsRecordTests
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import XCTest
@testable import NASAMeteorsRecord


class NASAMeteorsRecordTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func mockData() -> [MeteorModel]? {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: "MockData", withExtension: "json") else {
                    XCTFail("Missing file: MockData.json")
                    return nil
                }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let models = try decoder.decode([MeteorModel].self, from: data)

            return models
        }
        catch {
            return nil
        }

    }
    func testJSONParsing() throws {
        guard let firstMeteor = mockData()?.first else {

            XCTFail("No mock data available")

            return
        }

        XCTAssertEqual(firstMeteor.name, "Aachen")
        XCTAssertEqual(firstMeteor.mass, "21")

    }

    func testMeteorViewModel() throws {

        guard let firstMeteor = mockData()?.first else {

            XCTFail("No mock data available")

            return
        }

        let viewModel = MeteorViewModel(model: firstMeteor)

        XCTAssertEqual(viewModel.name, "Aachen")
        XCTAssertEqual(viewModel.mass, "21")
        XCTAssertEqual(viewModel.year, "1.1.1880")

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
