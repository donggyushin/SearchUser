//
//  SearchUserTextField.swift
//  Presentation
//
//  Created by 신동규 on 5/18/24.
//

import UIKit
import Combine
import RxCocoa
import RxSwift

final class SearchUserTextField: UIView {
    
    let text = PassthroughSubject<String, Never>()
    let search = PassthroughSubject<(), Never>()
    
    private lazy var textField = UITextField()
        .then { textField in
            textField.placeholder = "Search Users"
            textField.returnKeyType = .search
        }
    
    private let tapTrashIcon = UITapGestureRecognizer()
    private lazy var trashIcon = UIImageView(image: .init(systemName: "trash"))
        .then { image in
            image.tintColor = .label
            image.isUserInteractionEnabled = true
            image.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
            image.contentMode = .scaleAspectFit
            image.addGestureRecognizer(tapTrashIcon)
        }
    
    private let tapSearchIcon = UITapGestureRecognizer()
    private lazy var searchIcon = UIImageView(image: .init(systemName: "magnifyingglass"))
        .then { image in
            image.tintColor = .label
            image.isUserInteractionEnabled = true
            image.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
            image.contentMode = .scaleAspectFit
            image.addGestureRecognizer(tapSearchIcon)
        }
    
    private lazy var horizontalStackView = UIStackView(arrangedSubviews: [textField, trashIcon, searchIcon])
        .then { stackView in
            stackView.axis = .horizontal
        }
    
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        clipsToBounds = true
        snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func bind() {
        textField
            .rx
            .text
            .orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.text.send(text)
                self?.trashIcon.isHidden = text.isEmpty
            })
            .disposed(by: disposeBag)
        
        textField
            .rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.search.send()
            })
            .disposed(by: disposeBag)
        
        textField
            .rx
            .text
            .orEmpty
            .map({ $0.count >= 1 })
            .bind(to: textField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        tapTrashIcon
            .rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.textField.text = ""
            })
            .disposed(by: disposeBag)
        
        tapSearchIcon
            .rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.search.send()
            })
            .disposed(by: disposeBag)
    }
}
