//
//  UserTableViewCell.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 19.03.2023.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.layer.borderWidth = 2
          return imageView
      }()
    
    // view model set in UsersViewController 
    var viewModel: TableViewCellViewModelType? {
           didSet {
               usernameLabel.text = viewModel?.userName
              
               viewModel?.loadImage(from: (viewModel?.userImage)!, completion: { [weak self] image in
                   DispatchQueue.main.async {
                       self?.userImageView.image = image
                   }
                  
               })
           }
       }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
        
        userImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



