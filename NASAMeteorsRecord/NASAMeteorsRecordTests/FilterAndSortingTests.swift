//
//  FilterAndSortingTests.swift
//  NASAMeteorsRecordTests
//
//  Created by Ankush Kushwaha on 7/17/21.
//

import XCTest

class FilterAndSortingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSortByYear() throws {

        guard let meteorsViewMOdels = MockData().getMeteorsViewModels() else {
            XCTFail("No mock data models available")
            return
        }


        let sortByYearsModels = FilterAndSortSystem().sort(meteors: meteorsViewMOdels , sortType: .SortByYear )

        guard let first = sortByYearsModels?.first,
        let second = sortByYearsModels?[1],
        let third = sortByYearsModels?[2],
        let last = sortByYearsModels?.last else {

            XCTFail("Sort by year failed")
            return
        }

        XCTAssertEqual(first.name, "Albareto")
        XCTAssertEqual(first.id, "453")
        XCTAssertEqual(first.year, "1.1.1766")

        XCTAssertEqual(second.name, "Aire-sur-la-Lys")
        XCTAssertEqual(second.id, "425")
        XCTAssertEqual(second.year, "1.1.1769")

        XCTAssertEqual(third.name, "Alais")
        XCTAssertEqual(third.mass, "6000")
        XCTAssertEqual(third.id, "448")
        XCTAssertEqual(third.year, "1.1.1806")

        XCTAssertEqual(last.name, "Chelyabinsk")
        XCTAssertEqual(last.mass, "100000")
        XCTAssertEqual(last.id, "57165")
        XCTAssertEqual(last.year, "1.1.2013")
    }


    func testSortByMass() throws {

        guard let meteorsViewMOdels = MockData().getMeteorsViewModels() else {
            XCTFail("No mock data models available")
            return
        }


        let sortByYearsModels = FilterAndSortSystem().sort(meteors: meteorsViewMOdels , sortType: .SortByMass )

        guard let first = sortByYearsModels?.first,
        let second = sortByYearsModels?[1],
        let last = sortByYearsModels?.last else {

            XCTFail("Sort by year failed")
            return
        }


        XCTAssertEqual(first.name, "Aire-sur-la-Lys")
        XCTAssertEqual(first.id, "425")
        XCTAssertEqual(first.mass, nil)
        XCTAssertEqual(first.year, "1.1.1769")

        XCTAssertEqual(second.name, "Angers")
        XCTAssertEqual(second.id, "2301")
        XCTAssertEqual(second.year, "1.1.1822")

        XCTAssertEqual(last.name, "Sikhote-Alin")
        XCTAssertEqual(last.id, "23593")
        XCTAssertEqual(last.mass, "23000000")
    }

    func testFilterMeteorsOnlyFrom1900() throws {

        guard let meteorsViewMOdels = MockData().getMeteorsViewModels() else {
            XCTFail("No mock data models available")
            return
        }


        let sortByYearsModels = FilterAndSortSystem().sort(meteors: meteorsViewMOdels , sortType: .ShowOnlyMeteorsFrom1900 )

        XCTAssertEqual(sortByYearsModels?.count, 625)
    }
}
