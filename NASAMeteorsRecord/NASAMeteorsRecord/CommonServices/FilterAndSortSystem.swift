//
//  FilterAndSortSystem.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import Foundation

class FilterAndSortSystem {

    enum FilterOptionType: String {

        case ShowAll = "Show All"
        case SortByName = "Sort By Name"
        case SortByYear = "Sort By Year"
        case SortByMass = "Sort By Mass"
        case ShowOnlyMeteorsFrom1900 = "Show Only Meteors From 1900"
    }

    var currentFilterType : FilterOptionType! {
        didSet {
            NotificationCenter.default.post(name: .didUpdateFilter, object: nil)
        }
    }

    func sort(meteors: [MeteorViewModel],
              sortType: FilterOptionType) -> [MeteorViewModel]? {

        switch sortType {

        case .ShowAll:
            return meteors

        case .SortByYear:

            let meteors = meteors.sorted {
                if let date1 = $0.date, let date2 = $1.date {
                    return date1 < date2
                }
                return false
            }
            return meteors

        case .SortByName:

            let meteors = meteors.sorted {
                $0.name ?? "" < $1.name ?? ""
            }
            return meteors

        case .SortByMass:

            let meteors = meteors.sorted {
                if let mass1 = Double($0.mass ?? "0"),
                   let mass2 = Double($1.mass ?? "0") {

                    return mass1 < mass2
                }
                return false
            }
            return meteors

        case .ShowOnlyMeteorsFrom1900:

            let referenceDateString = "1900-01-01T00:00:00.000"

            let dateFormatter = DateFormatter.iso8601Full
            let referenceDate = dateFormatter.date(from:referenceDateString)!
            let meteors = meteors.filter {
                if let date1 = $0.date {
                    return date1 > referenceDate
                }
                return false
            }

            return meteors

        }
    }
}
