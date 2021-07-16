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

    func setFavourite (id: String) {

        if var savedIds = getFavourites(),
           savedIds.count > 0 {

            savedIds.append(id)
            UserDefaults.standard.setValue(savedIds, forKey: UserDefaultKey.favourites)

        } else {
            // first favourite item

            UserDefaults.standard.setValue([id], forKey: UserDefaultKey.favourites)
        }
    }

    func getFavourites() -> [String]? {

        let ids = UserDefaults.standard.value(forKey: UserDefaultKey.favourites) as? [String]

        return ids
    }

    func removeFromFavourite(id: String) {
        if var savedIds = getFavourites(),
           savedIds.count > 0 {

            
            savedIds.removeAll{$0 == id}

            UserDefaults.standard.setValue(savedIds, forKey: UserDefaultKey.favourites)

        }
    }

}
