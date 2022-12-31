//
//  ViewController.swift
//  UITableViewDiffableDataSource
//
//  Created by MohamedOsama on 31/12/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView: UITableView = {
       let table = UITableView()
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    enum Section {
        case first
        case second
    }
    
    struct Car: Hashable {
        let id = UUID().uuidString
        let name: String
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section,Car>!
    private var cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.name
            return cell
        })
        
        title = "Car News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNewCar))
    }
    
    @objc private func addNewCar() {
        let alertAction = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        for i in 0...100 {
            alertAction.addAction(UIAlertAction(title: "Car-X\(i)", style: .default, handler: { [weak self] action in
                guard let self else { return }
                self.cars.append(Car(name: "Car-X\(i)"))
                self.updateSnapShot()
            }))
        }
        
        alertAction.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertAction, animated: true)
    }
    
    private func updateSnapShot() {
        var animations : [UITableView.RowAnimation] = [.right, .automatic, .bottom, .fade, .middle]
        var snapshot = NSDiffableDataSourceSnapshot<Section,Car>()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(cars)
        dataSource.defaultRowAnimation = animations.randomElement() ?? .fade
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let car = dataSource.itemIdentifier(for: indexPath) else { return }
        print(car.name)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        UIView.animate(withDuration: 0.33) {
            cell.alpha = 0.33
            cell.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        } completion: { _ in
            UIView.animate(withDuration: 0.33) {
                cell.alpha = 1.0
                cell.transform = .identity
            }
        }

    }


}

