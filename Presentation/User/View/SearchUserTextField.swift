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
            textField.delegate = self
            textField.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
    
    private let tapTrashIcon = UITapGestureRecognizer()
    private lazy var trashIcon = UIImageView(image: .init(systemName: "xmark"))
        .then { image in
            image.tintColor = .label
            image.isUserInteractionEnabled = true
            image.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
            image.contentMode = .scaleAspectFit
            image.addGestureRecognizer(tapTrashIcon)
        }
    
    private lazy var textFieldContainer = UIView()
        .then { container in
            container.backgroundColor = .secondarySystemGroupedBackground
            container.layer.cornerRadius = 8
            container.clipsToBounds = true
            
            container.addSubview(trashIcon)
            trashIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(10)
            }
            
            container.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.right.equalTo(trashIcon.snp.left)
                make.left.equalToSuperview().inset(10)
            }
        }
    
    private lazy var searchButton = UIButton(configuration: .borderedProminent(), primaryAction: .init(handler: { [weak self] _ in
        self?.search.send()
    }))
        .then { button in
            button.setTitle("Search", for: .normal)
            button.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
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
        snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        addSubview(textFieldContainer)
        textFieldContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(searchButton.snp.left).offset(-15)
            make.left.equalToSuperview()
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
                self?.searchButton.isEnabled = !text.isEmpty
            })
            .disposed(by: disposeBag)
        
        tapTrashIcon
            .rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.textField.text = ""
                self?.trashIcon.isHidden = true
                self?.searchButton.isEnabled = false
                self?.text.send("")
            })
            .disposed(by: disposeBag)
    }
}

extension SearchUserTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text?.isEmpty == false
    }
}
