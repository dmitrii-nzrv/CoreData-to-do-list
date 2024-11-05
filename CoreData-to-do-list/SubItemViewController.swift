//
//  SubItemViewController.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 05.11.2024.
//

import UIKit
import CoreData

class SubItemViewController: UIViewController {
    
    var folder: Folder
    var items: [Item] = [] // Хранение подзадач для текущей папки
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить подзадачу", for: .normal)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        return button
    }()
    
    init(folder: Folder) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadItems() // Загружаем подзадачи при открытии контроллера
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems() // Обновляем данные при каждом возврате на экран
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = folder.title ?? "Подзадачи"
        
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadItems() {
        if let itemsSet = folder.items as? Set<Item> {
            items = Array(itemsSet).sorted { $0.date ?? Date() < $1.date ?? Date() }
        }
        tableView.reloadData()
    }
    
    @objc func addNewItem() {
        let newItem = Item(context: CoreDataManager.shared.context)
        newItem.id = UUID().uuidString
        newItem.text = "Новая подзадача"
        newItem.date = Date()
        newItem.folder = folder
        
        CoreDataManager.shared.saveContext()
        loadItems() // Обновляем список подзадач после добавления новой
    }
    
    func editItem(_ item: Item) {
        let editVC = EditItemViewController(item: item)
        editVC.delegate = self // Устанавливаем делегат для получения уведомления о сохранении
        present(editVC, animated: true, completion: nil)
    }
}

// MARK: - EditItemViewControllerDelegate

extension SubItemViewController: EditItemViewControllerDelegate {
    func didSaveItem() {
        // Обновляем данные после сохранения
        loadItems()
    }
}

// MARK: - UITableViewDataSource и UITableViewDelegate

extension SubItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        
        let dateText = item.date?.formatted() ?? "Нет даты"
        cell.textLabel?.text = "\(item.text ?? "Без текста") - \(dateText)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        editItem(item) // Открываем экран редактирования
    }
}
