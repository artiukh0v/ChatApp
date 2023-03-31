//
//  UsersViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 26.02.2023.
//

import UIKit
import SDWebImage
class UsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    // identifire of cell
    private let reuseIdentifier = "UserTableViewCell"
    // dependency of view model
    private var viewModel: TableViewViewModelType!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableViewDelegate and TableViewDataSource
        tableView.dataSource = self
        tableView.delegate = self
        // initializing viewModel with FB
        viewModel = TableViewViewModel(FB: UsersFBRequests())
         
        // set users in view model and reload data of table view
        viewModel.FB.getAllUsers { [weak self] users in
            self?.viewModel.users = users
            self?.tableView.reloadData()
        }
        
    }
    
    
}
// MARK: Table View extension
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: TableiewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserTableViewCell {
            // creating cell viewmodel
            let viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            // set cell view model
            cell.viewModel = viewModel
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // creating property of ChatViewController type
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        // sets username of user in navigationItem title
        chatVC.navigationItem.title = viewModel.users[indexPath.row].userName
        
        // set propertys for chatVC
        chatVC.otherId = viewModel.users[indexPath.row].userId
        chatVC.avatarURL = viewModel.users[indexPath.row].userAvatarUrl
        
        // going in chatVC
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
