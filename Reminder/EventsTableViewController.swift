//
//  EventsTableViewController.swift
//  Reminder
//
//  Created by Ivan Sadovich on 10.01.22.
//

import UIKit
import CoreData
import UserNotifications
class EventsTableViewController: UITableViewController {
var events = [Event]()
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // после нажатия save мы сохраняем объект в контекст, а затем загружаем контекс в массив. Потом уже с массива данные заполняются в ячейки
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Event.fetchRequest() as NSFetchRequest<Event>
        
        let sortDescriptor1 = NSSortDescriptor(key: "thirdLine", ascending:true)
        let sortDescriptor2 = NSSortDescriptor(key: "firstLine", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            events = try context.fetch (fetchRequest)
        } catch let error {
            print(" Unable to load data due to error \(error) ")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCellIdentifier", for: indexPath)
        let event = events[indexPath.row]
        let firstLine = event.firstLine ?? " "
        let secondLine = event.secondLine ?? " "
        cell.textLabel?.text = firstLine + " (" + secondLine + ")"
        if let date = event.thirdLine as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }
       
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if events.count > indexPath.row {
            let event = events[indexPath.row]
            if let identifier = event.eventID {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(event)
            events.remove(at: indexPath.row)
            // все изменения в контексте нужно сохранять
            do {
                try context.save()
            } catch let error {
                print ("Unable to save due error \(error) ")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }

        
        
    }
    

    

    
    // MARK: - Navigation

}
