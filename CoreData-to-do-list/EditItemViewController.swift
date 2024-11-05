//
//  EditItemViewController.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 05.11.2024.
//

import UIKit

protocol EditItemViewControllerDelegate: AnyObject {
    func didSaveItem()
}

class EditItemViewController: UIViewController {
    
    var item: Item
    weak var delegate: EditItemViewControllerDelegate?
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.text = item.text
        return textView
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = item.date ?? Date()
        return datePicker
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return button
    }()
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(textView)
        view.addSubview(datePicker)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 100),
            
            datePicker.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func saveChanges() {
        // Сохраняем изменения в item
        item.text = textView.text
        item.date = datePicker.date
        
        // Сохраняем контекст Core Data
        CoreDataManager.shared.saveContext()
        
        // Уведомляем делегата об изменении
        delegate?.didSaveItem()
        
        // Закрываем контроллер после сохранения
        dismiss(animated: true, completion: nil)
    }
}
