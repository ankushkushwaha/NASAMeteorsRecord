//
//  MockDataFetchingTests.swift
//  NASAMeteorsRecordTests
//
//  Created by Ankush Kushwaha on 7/17/21.
//

import XCTest

class MockDataFetchingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMockDataFetching() {

        guard let models = MockData().getModels() else {

            XCTFail("Models cannot be fetched from mock data file")
            return
        }

        XCTAssert(models.count == 1000, "Models cannot be parsed from mock data")
    }

}


class MockData {

    func getModels() -> [MeteorModel]? {

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
            XCTFail("Data cannot be parsed to models from mockdata file")

            return nil
        }
    }
}
