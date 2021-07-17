//
//  MeteorViewModel.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import Foundation

struct MeteorViewModel {
    let id: String
    let name: String?
    let mass: String?
    let year: String?
    let location: [Double]?
    let date: Date?
    var isFavourite: Bool = false

    // Dependancy Injection

    init(model: MeteorModel) {
        id = model.id
        name = model.name
        mass = model.mass
        year = model.year?.dateDisplayString
        date = model.year
        location = model.geolocation?.coordinates
    }

}
