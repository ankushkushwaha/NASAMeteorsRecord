//
//  FilterViewController.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    weak var filterSystem :FilterAndSortSystem?

    let optionArray = [FilterAndSortSystem.FilterOptionType.ShowAll,
                       FilterAndSortSystem.FilterOptionType.SortByYear,
                       FilterAndSortSystem.FilterOptionType.SortByName,
                       FilterAndSortSystem.FilterOptionType.SortByMass,
                       FilterAndSortSystem.FilterOptionType.ShowOnlyMeteorsFrom1900
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")

    }

    deinit {
        print("deFilterViewController deinit")
    }

}


extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArray.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell") {

            let sortType = optionArray[indexPath.row]

            if filterSystem?.currentFilterType == sortType {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none

            }

            cell.textLabel?.text = optionArray[indexPath.row].rawValue

            return cell
        }

        return UITableViewCell()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortType = optionArray[indexPath.row]
        filterSystem?.currentFilterType = sortType

        tableView.reloadData()
    }
}
