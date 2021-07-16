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
    let nametype: String?
    let recclass: String?
    let mass: String?
    let fall: Fall?
    let year: Date?
    let reclat: String?
    let reclong: String?
    let geolocation: Geolocation?
    let computedRegionCbhkFwbd: String?
    let computedRegionNnqa25F4: String?
}

enum Fall: String, Codable {
    case fell = "Fell"
    case found = "Found"
}

struct Geolocation: Codable {
    let type: String?
    let coordinates: [Double]?
}
