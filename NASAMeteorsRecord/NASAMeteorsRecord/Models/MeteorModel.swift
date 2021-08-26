//
//  Meteor.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import Foundation

struct MeteorModel: Codable {
    let id: String
    let name: String?
    let mass: String?
    let year: Date?
    let geolocation: Geolocation?
}

struct Geolocation: Codable {
    let type: String?
    let coordinates: [Double]?
}
