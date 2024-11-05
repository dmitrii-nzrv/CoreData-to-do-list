//
//  ViewController.swift
//  CoreData-to-do-list
//
//  Created by Dmitrii Nazarov on 03.11.2024.
//


import UIKit
import CoreData



class MainViewController: UIViewController {

    var folders: [Folder] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    

        fetchFolders() // Вызов fetchFolders при первом запуске
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFolders() // Вызов fetchFolders при возвращении на экран
    }
    
    private func setupUI() {
        title = "Folders"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func addFolder() {
        let alert = UIAlertController(title: "Новая папка", message: "Введите название папки", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Название папки"
        }
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { _ in
            // Получаем текст из текстового поля
            guard let folderName = alert.textFields?.first?.text, !folderName.isEmpty else {
                print("Название папки не может быть пустым")
                return
            }
            
            // Создаем новую папку с указанным названием
            let newFolder = Folder(context: CoreDataManager.shared.context)
            newFolder.id = UUID().uuidString
            newFolder.title = folderName
            
            CoreDataManager.shared.saveContext()
            self.fetchFolders() // Обновляем данные после добавления новой папки
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }


    
    private func fetchFolders() {
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            folders = try CoreDataManager.shared.context.fetch(fetchRequest)
            print("Загружено \(folders.count) папок")
            for folder in folders {
                print("Папка: \(folder.title ?? "Без названия")")
                if let items = folder.items as? Set<Item> {
                    print("  Количество подзадач: \(items.count)")
                    for item in items {
                        print("  - Item: \(item.text ?? "Нет текста") с датой: \(item.date ?? Date())")
                    }
                }
            }
            tableView.reloadData()
        } catch {
            print("Ошибка при получении папок: \(error)")
        }
    }


}

// MARK: - UITableViewDataSource и UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let folder = folders[indexPath.row]
        cell.textLabel?.text = folder.title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let folder = folders[indexPath.row]
        let subItemVC = SubItemViewController(folder: folder)
        navigationController?.pushViewController(subItemVC, animated: true)
    }
}
