//
//  AddRegistrationTableViewController.swift
//  Manzana
//
//  Created by  Apple24 on 04/02/2019.
//  Copyright © 2019  Apple24. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController,
                                          SelectRoomTypeTableViewControllerDelegate { // хороший пример метода взять на вооружение

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper! {
        didSet {
            numberOfChildrenStepper.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            numberOfChildrenStepper.transform = CGAffineTransform(rotationAngle: .pi) // повернуть
        }
    }
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
   
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    // показывает или скрывает DatePicker
    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var roomType: RoomType?
    var registration: Registration? {

        guard let roomType = roomType else { return nil }

        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn

        return Registration(
            firstName: firstName,
            lastName: lastName,
            emailAddress: email,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfAdults: numberOfAdults,
            numberOfGhildren: numberOfChildren,
            roomType: roomType,
            wiFi: hasWifi
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
        
        updateDateViews()
        numberOfAdultsStepper.value = 2
        // дети без взрослых
        numberOfAdultsStepper.minimumValue = 1
        
        checkInDatePicker.locale = Locale(identifier: "ru_RU")
        checkOutDatePicker.locale = Locale(identifier: "ru_RU")
        updateNumberOfGuests()
        updateRoomType()

    }

    func updateDateViews() {
        // + сутки
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(24 * 60 * 60)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = " dd LLL yy cccccc "
        dateFormatter.locale = Locale(identifier: "ru_RU") // русифецируем
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        roomTypeLabel.text = roomType?.name ?? "Не выбран"
    }
    
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SelectRoomType" {
            let destinationViewController = segue.destination as?  SelectRoomTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.roomType = roomType
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifi = wifiSwitch.isOn
        let roomChoice = roomType?.name ?? "Не выбран"
        
        print("""
            ============================================
                    Имя: \(firstName)
                Фамилия: \(lastName)
                 Е-mail: \(email)
            Дата заезда: \(checkInDate)
            Дата выезда: \(checkOutDate)
               Взрослые: \(numberOfAdults)
                   Дети: \(numberOfChildren)
               roomType: \(roomChoice)
                  Wi-Fi: \(wifi ? "да" : "нет" )
            --------------------------------------------
        """)
    
    }
    // меняем значения  Picker и отображаем Label
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    // увеличиваем на 1
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            wifiLabel.text = "20 ₽"
        } else {
            wifiLabel.text = " -- "
        }
    }
}

// MARK: -   UITableViewDelegate
extension AddRegistrationTableViewController {
    // высота ячейки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? 216 : 0
        case checkOutDatePickerIndexPath:
          return isCheckOutDatePickerShown ? 216 : 0
        default:
            return 44
        }
    }
    
    //  выбор ячейки по Тab
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case checkInDateLabelIndexPath:
            if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
            } else if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            } else {
                isCheckInDatePickerShown = true
            }
        case checkOutDateLabelIndexPath:
            if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
            } else if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            } else {
                isCheckOutDatePickerShown = true
            }
        default:
            //  скрываем DatePicker если не активны
            isCheckInDatePickerShown = false
            isCheckOutDatePickerShown = false
        }
        // обновить частично
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
