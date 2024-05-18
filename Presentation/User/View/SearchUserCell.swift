//
//  SearchUserCell.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import UIKit
import Kingfisher
import MockData

final class SearchUserCell: UITableViewCell {
    static let identifier = "SearchUserCell"
    
    private lazy var avatarImageView = UIImageView()
        .then { imageView in
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
        }
    
    private lazy var loginLabel = UILabel()
    private lazy var urlLabel = UILabel()
        .then { label in
            label.textColor = .secondaryLabel
        }
    
    private lazy var verticalStackView = UIStackView(arrangedSubviews: [
        loginLabel,
        urlLabel
    ])
        .then { stackView in
            stackView.axis = .vertical
        }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        avatarImageView.image = nil
        loginLabel.text = nil
        urlLabel.text = nil
    }
    
    func configUI(user: User) {
        let url = URL(string: user.avatarUrl ?? "")
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person"), options: [.transition(.fade(0.2))])
        loginLabel.text = user.login
        urlLabel.text = user.url
    }
    
    private func configUI() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(avatarImageView.snp.right).offset(20)
        }
    }
}

#Preview {
    let cell = SearchUserCell()
    cell.configUI(user: .init(domain: USER_1))
    return cell
}
