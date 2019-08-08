//
//  ContracionTableTableViewController.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-27.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class ContractionTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = NSLocalizedString("Contractions", comment: "Contractions")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contraction.getContractions().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ContractionTableViewCell"
        var cell: ContractionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ContractionTableViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "ContractionTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ContractionTableViewCell
        }

        let contraction = Contraction.getContractions()[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MMM @ hh:mm:ss")
        
        cell.start = dateFormatter.string(from: contraction.start)
        cell.intensity = String(round(contraction.intensity * 10)/10)
        
        if contraction.end == Date.distantFuture {
            cell.end = NSLocalizedString("Current Contraction", comment: "Current Contraction")
            cell.duration = NSLocalizedString("N/A", comment: "Not applicable abbrevation")
        } else {
            cell.end = dateFormatter.string(from: contraction.end)
            cell.duration = contraction.end.timeIntervalSince(contraction.start).DisplayableString()
        }
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive, title: title) { (action, view, completionHandler) in
            let contraction = Contraction.getContractions()[indexPath.row]
            Contraction.delete(contraction: contraction)
            tableView.reloadData()
        }
        action.title = NSLocalizedString("Delete", comment: "Delete")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let contractions = Contraction.getContractions()
        
        if contractions.isEmpty {
            return false
        } else {
            let contraction = contractions[indexPath.row]
            return contraction.end != Date.distantFuture
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
