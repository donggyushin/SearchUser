//
//  SearchUserEmptyListView.swift
//  Presentation
//
//  Created by 신동규 on 5/19/24.
//

import UIKit

final class SearchUserEmptyListView: UIView {
    
    private lazy var descriptionLabel = UILabel()
        .then { label in
            label.text =
            """
            No users have been searched.
            Use the textfield above, search for the users you want.
            """
            label.numberOfLines = 0
            label.textAlignment = .center
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#Preview {
    SearchUserEmptyListView()
}
