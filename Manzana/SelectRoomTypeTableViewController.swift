//
//  SelectRoomTypeTableViewController.swift
//  Manzana
//
//  Created by  Apple24 on 06/02/2019.
//  Copyright © 2019  Apple24. All rights reserved.
//

import UIKit

class SelectRoomTypeTableViewController: UITableViewController {

    var delegate: SelectRoomTypeTableViewControllerDelegate?
    var roomType: RoomType?
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        
        cell.textLabel?.text = roomType.name
        cell.detailTextLabel?.text = "₽ \(roomType.price)"
        cell.accessoryType = roomType == self.roomType ? .detailButton : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = RoomType.all[indexPath.row]
        delegate?.didSelect(roomType: roomType!)
        tableView.reloadData()
    }
}

protocol SelectRoomTypeTableViewControllerDelegate {
    func didSelect(roomType: RoomType)
}
