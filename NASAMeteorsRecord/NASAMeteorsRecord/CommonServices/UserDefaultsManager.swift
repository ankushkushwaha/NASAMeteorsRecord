//
//  UserDefaultsManager.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import UIKit

struct UserDefaultsManager {

    struct UserDefaultKey {
        static let favourites = "favourites"
    }

    private let userDefaultInstance: UserDefaults!

    // dependancy injection for testing purpose
    init(userDefault: UserDefaults = UserDefaults.standard) {

        userDefaultInstance = userDefault
    }

    func setFavourite (id: String) {

        if var savedIds = getFavourites(),
           savedIds.count > 0,
           !savedIds.contains(id) {

            savedIds.append(id)
            userDefaultInstance.setValue(savedIds, forKey: UserDefaultKey.favourites)

        } else {
            // first favourite item

            userDefaultInstance.setValue([id], forKey: UserDefaultKey.favourites)
        }
    }

    func getFavourites() -> [String]? {

        let ids = userDefaultInstance.value(forKey: UserDefaultKey.favourites) as? [String]

        return ids
    }

    func removeFromFavourite(id: String) {
        if var savedIds = getFavourites(),
           savedIds.count > 0 {

            
            savedIds.removeAll{$0 == id}

            userDefaultInstance.setValue(savedIds, forKey: UserDefaultKey.favourites)

        }
    }

}
