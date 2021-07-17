//
//  FavouriteFeatureTests.swift
//  NASAMeteorsRecordTests
//
//  Created by Ankush Kushwaha on 7/17/21.
//

import XCTest

class FavouriteFeatureTests: XCTestCase {

    private var userDefaults: UserDefaults!

    override func setUpWithError() throws {

        // Reset own userdefaults for testing
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetFavourite() throws {

        let userdefaultManager = UserDefaultsManager(userDefault: userDefaults)

        guard let firstMeteor = MockData().getModels()?.first,
              let lastMeteor = MockData().getModels()?.last else {

            XCTFail("No mock data available")
            return
        }

        let vm1 = MeteorViewModel(model: firstMeteor)
        let vm2 = MeteorViewModel(model: lastMeteor)

        userdefaultManager.setFavourite(id: vm1.id)
        var favourite = userdefaultManager.getFavourites() ?? []
        XCTAssert(favourite.contains(vm1.id), "Set Favourite failed")



        userdefaultManager.setFavourite(id: vm2.id)
        // fetch again
        favourite = userdefaultManager.getFavourites() ?? []
        XCTAssert(favourite.contains(vm2.id), "Set Favourite failed")

        XCTAssert(favourite.count == 2 , "Set Favourite failed")
    }

    func testRemoveFavourite() throws {

        let userdefaultManager = UserDefaultsManager(userDefault: userDefaults)

        guard let firstMeteor = MockData().getModels()?.first else {

            XCTFail("No mock data available")
            return
        }

        let vm1 = MeteorViewModel(model: firstMeteor)

        userdefaultManager.setFavourite(id: vm1.id)

        var favourite = userdefaultManager.getFavourites() ?? []
        XCTAssert(favourite.contains(vm1.id), "Set Favourite failed")


        userdefaultManager.removeFromFavourite(id: vm1.id)

        favourite = userdefaultManager.getFavourites() ?? []
        XCTAssert(!favourite.contains(vm1.id), "Remove Favourite failed")

        XCTAssert(favourite.count == 0 , "Remove Favourite failed")

    }
}
