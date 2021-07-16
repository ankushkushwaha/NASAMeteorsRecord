//
//  HomeViewController.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let refreshControl = UIRefreshControl()

    private var meteorsData: [MeteorViewModel]? = [] // to show in table view

    private var allMeteorsViewModel: [MeteorViewModel] = [] // for cache

    private var filterSystem = FilterAndSortSystem()

    override func viewDidLoad() {
        super.viewDidLoad()

        // by default we show all meteors -> .ShowAll
        filterSystem.currentFilterType = .ShowAll

        setupTableView()

        refreshData(nil)

        setNavigationBar()

        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter(_:)), name: .didUpdateFilter, object: nil)

    }

    @objc func applyFilter(_ sender: AnyObject?) {

        guard let sortType = filterSystem.currentFilterType else {
            return
        }
        self.meteorsData = FilterAndSortSystem().sort(meteors: allMeteorsViewModel, sortType: sortType )

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    private func setNavigationBar() {

        let rightBarButton = UIBarButtonItem(title: "Filters", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openFilters(_:)))
            self.navigationItem.rightBarButtonItem = rightBarButton

        self.title = "Meteors List"
    }

    @objc func openFilters(_ sender: AnyObject?) {
        let vc = FilterViewController()
        vc.filterSystem = filterSystem
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: MeteorTableViewCell.nibName(),
                                 bundle: nil),
                           forCellReuseIdentifier: "MeteorTableViewCell")

        tableView.delegate = self
        tableView.dataSource = self

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
         tableView.addSubview(refreshControl)

    }

    @objc func refreshData(_ sender: AnyObject?) {

        filterSystem.currentFilterType = .ShowAll

        NetworkService().fetchMeteorsData { [unowned self] (meteorModelArray, error) in

            self.allMeteorsViewModel = meteorModelArray?.map {return MeteorViewModel(model: $0)} ?? []

            self.meteorsData = allMeteorsViewModel // no filters at this stage

            DispatchQueue.main.async {
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteorsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MeteorTableViewCell") as? MeteorTableViewCell {

            cell.model = meteorsData?[indexPath.row]
            cell.accessoryType = .disclosureIndicator

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if let coordinates = meteorsData?[indexPath.row].location,
           let lat = coordinates.last,
           let long = coordinates.first {
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            if (CLLocationCoordinate2DIsValid(centerCoordinate)) {

                let vc = MapViewController()
                vc.meteorViewModel = meteorsData?[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)

            } else {

                let alert = UIAlertController(title: "", message: "Location of this meteor is invalid.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
}
