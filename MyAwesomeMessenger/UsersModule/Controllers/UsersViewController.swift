//
//  UsersViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 26.02.2023.
//

import UIKit
import SDWebImage

class UsersViewController: UIViewController {
    
   
    private let tableView = UITableView()

    // identifier of cell
    private let reuseIdentifier = "UserTableViewCell"
    // dependency of view model
    private var viewModel: TableViewViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        // initializing viewModel with FB
        viewModel = TableViewViewModel(FB: UsersFBRequests())

        // TableViewDelegate and TableViewDataSource
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserTableViewCell {
            // creating cell viewmodel
            let viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            // set cell view model
            cell.viewModel = viewModel
            return cell
        }
        return UITableViewCell()
    }

    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // creating property of ChatViewController type
        let chatVC = ChatViewController()
        // sets username of user in navigationItem title
        chatVC.navigationItem.title = viewModel.users[indexPath.row].userName

        // set properties for chatVC
        chatVC.otherId = viewModel.users[indexPath.row].userId
        chatVC.avatarURL = viewModel.users[indexPath.row].userAvatarUrl

        // going to chatVC
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

