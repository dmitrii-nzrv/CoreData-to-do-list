//
//  Helper.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 05.11.2024.
//


import UIKit

func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.isSecureTextEntry = isSecure
    textField.layer.cornerRadius = 15
    textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    textField.font = UIFont.systemFont(ofSize: 18)
    textField.textColor = .black
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    
    textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
    
    return textField
}

func createLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = .black
    label.numberOfLines = 0
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
    return label
}

func createBtn(title: String, BGColor: UIColor, textColor: UIColor, target: Any?, action: Selector) -> UIButton {
    let btn = UIButton()
    btn.setTitle(title, for: .normal)
    btn.setTitleColor(textColor, for: .normal)
    btn.titleLabel?.font = .systemFont(ofSize: 14)
    btn.backgroundColor = BGColor
    btn.layer.cornerRadius = 15
    btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
    btn.translatesAutoresizingMaskIntoConstraints = false
    
    btn.addTarget(target, action: action, for: .touchUpInside)
    return btn
}

func addSubviews(_ subviews: [UIView], to view: UIView) {
    subviews.forEach(view.addSubview)
}
