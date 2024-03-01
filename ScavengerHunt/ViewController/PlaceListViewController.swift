//
//  TaskListViewController.swift
//  ScavengerHunt
//
//  Created by Fredy Camas on 2/28/24.
//

import UIKit

struct Constants{
    
    static let taskIdentifier = "TaskCell"
}

class PlaceListViewController: UIViewController {
    var tableView: UITableView!
    var emptyStateLabel: UILabel!
    
    var tasks = [Task]() {
        didSet {
            emptyStateLabel.isHidden = !tasks.isEmpty
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
        tableView.register(TaskCell.self, forCellReuseIdentifier: Constants.taskIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        //EmptyState Label
        emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        emptyStateLabel.center = view.center
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.text = "No tasks"
        view.addSubview(emptyStateLabel)
        
        // Set navigation item title
        title = titleText
    }
    
    private func populateMockData(){
        tasks = Task.mockedTasks
    }

    
    // Function to present the compose view controller
//    func presentComposeViewController(){
//        let composeViewController = TaskComposeViewController()
//        
//        //Update the task array for any new task passed back
//        composeViewController.onComposeTask = { [weak self] task in
//            self?.tasks.append(task)
//        }
//        let composeNavController = UINavigationController(rootViewController: composeViewController)
//        self.present(composeNavController, animated: true, completion: nil)
//    }
    
    //Function to presetn the detail view controller
    func presentDetailViewController(for task: Task){
        let detailViewController = TaskDetailViewController()
        detailViewController.task = task
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PlaceListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskIdentifier, for: indexPath) as! TaskCell
        cell.configure(with: tasks[indexPath.row])
        return cell
    }

}

extension PlaceListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetailViewController(for: tasks[indexPath.row])
    }
}
