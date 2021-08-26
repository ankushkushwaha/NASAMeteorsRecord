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

    private var modifiedMeteorsData: [MeteorViewModel]? = [] // to show in table view

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

        refreshTableViewUI()
    }

    @objc func openFilters(_ sender: AnyObject?) {
        let vc = FilterViewController()
        vc.filterSystem = filterSystem
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setNavigationBar() {

        let rightBarButton = UIBarButtonItem(title: "Filters", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openFilters(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton

        self.title = "Meteors List"
    }

    @objc func refreshData(_ sender: AnyObject?) {

        NetworkService().fetchMeteorsData { [weak self] (meteorModelArray, error) in

            DispatchQueue.main.async {

                if let error = error {

                    var text = error.localizedDescription

                    if let error = error as? AppErrors {
                        text = error.description
                    }
                    let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)

                } else if let array = meteorModelArray,
                          array.count > 0 {

                    self?.allMeteorsViewModel = meteorModelArray?.map {return MeteorViewModel(model: $0)} ?? []

                    self?.refreshTableViewUI()

                    self?.refreshControl.endRefreshing()

                } else {

                    let alert = UIAlertController(title: "", message: "No meteors available.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
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

    //Call this methos instead if tableview->reloadData(), so that all current selected filters can be applied
    private func refreshTableViewUI() {

        guard let sortType = filterSystem.currentFilterType else {
            return
        }
        DispatchQueue.main.async {

            // STEP 1: apply favourite modification on data

            let dataWithFavouriteStatus = self.assignFavouriteStatusToViewModels(viewModels: self.allMeteorsViewModel)


            // STEP 2:  apply sorting/filter on data

            let sortedDataWithFavouriteStatus = FilterAndSortSystem().sort(meteors: dataWithFavouriteStatus ?? [], sortType: sortType )

            self.modifiedMeteorsData = sortedDataWithFavouriteStatus

            // STEP 3: Refresh UI
            self.tableView.reloadData()
        }
    }

    private func assignFavouriteStatusToViewModels(viewModels: [MeteorViewModel]) -> [MeteorViewModel]? {

        guard let favouriteIds = UserDefaultsManager().getFavourites() else {
            return viewModels
        }

        let vms = viewModels.map { viewmodel -> MeteorViewModel in

            var mutableVM = viewmodel

            mutableVM.isFavourite = favouriteIds.contains(mutableVM.id)

            return mutableVM
        }

        return vms
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedMeteorsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MeteorTableViewCell") as? MeteorTableViewCell {

            cell.model = modifiedMeteorsData?[indexPath.row]
            cell.accessoryType = .disclosureIndicator

            cell.delegate = self
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let coordinates = modifiedMeteorsData?[indexPath.row].location,
           let lat = coordinates.last,
           let long = coordinates.first {
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            if (CLLocationCoordinate2DIsValid(centerCoordinate)) {

                let vc = MapViewController()
                vc.meteorViewModel = modifiedMeteorsData?[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)

            } else {

                let alert = UIAlertController(title: "", message: "Location of this meteor is invalid.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        }
    }
}


extension HomeViewController: MeteorTableViewCellDelegate {
    
    func favouriteButtonClicked(model: MeteorViewModel) {

        if model.isFavourite {
            UserDefaultsManager().removeFromFavourite(id: model.id)
        } else {

            UserDefaultsManager().setFavourite(id: model.id)
        }

        refreshTableViewUI()
    }
}
