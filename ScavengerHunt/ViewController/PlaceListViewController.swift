//
//  PlaceListViewController.swift
//  ScavengerHunt
//
//  Created by Fredy Camas on 2/28/24.
//

import UIKit

struct Constants{
    
    static let placeIdentifier = "PlaceCell"
}

class PlaceListViewController: UIViewController {
    var tableView: UITableView!
    var emptyStateLabel: UILabel!
    
    var places = [Place]() {
        didSet {
            emptyStateLabel.isHidden = !places.isEmpty
            tableView.reloadData()
        }
    }
    
    var titleText: String = "Photo Scavenger Hunt" {
        didSet {
            title = titleText // Setting the title of the view controller
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupUI()
        populateMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // This will reload data in order to reflect any changes made to a task after returning from the detail screen.
        tableView.reloadData()
    }

    
    private func setupUI() {
        //Table View Programmatically
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(PlaceCell.self, forCellReuseIdentifier: Constants.placeIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        //EmptyState Label
        emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        emptyStateLabel.center = view.center
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.text = "No Places"
        view.addSubview(emptyStateLabel)
        
        // Set navigation item title
        title = titleText
    }
    
    private func populateMockData(){
        places = Place.mockedPlaces
    }
    
    //MARK: - to implement  add more task (optional)

/*
     Function to present the compose view controller
    func presentComposeViewController(){
        let composeViewController = PlaceComposeViewController()
        
        //Update the place array for any new task passed back
        composeViewController.onComposeTask = { [weak self] place in
            self?.places.append(place)
        }
        let composeNavController = UINavigationController(rootViewController: composeViewController)
        self.present(composeNavController, animated: true, completion: nil)
    }
    */
    //Function to presetn the detail view controller
    func presentDetailViewController(for task: Place){
        let detailViewController = PlaceDetailViewController()
        detailViewController.place = task
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PlaceListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.placeIdentifier, for: indexPath) as! PlaceCell
        cell.configure(with: places[indexPath.row])
        return cell
    }

}

extension PlaceListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetailViewController(for: places[indexPath.row])
    }
}
