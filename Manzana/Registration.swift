//
//  Registration.swift
//  Manzana
//
//  Created by  Apple24 on 04/02/2019.
//  Copyright © 2019  Apple24. All rights reserved.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date      // заезд
    var checkOutDate: Date     // выезд
    
    var numberOfAdults: Int    // количество взрослых
    var numberOfGhildren: Int  // количество детей
    
    var roomType: RoomType      // тип комнаты
    var wiFi: Bool
}

struct RoomType {
    var id: Int            // id
    var name: String       //
    var shortName: String  // код
    var price: Int         // цена
    
    static var all: [RoomType] {
        return [
            RoomType(id: 1, name: "Две кровати", shortName: "2Q", price: 179),
            RoomType(id: 2, name: "Одна кровать", shortName: "K", price: 209),
            RoomType(id: 3, name: "Люкс", shortName: "PHS", price: 309),
        ]
    }
}

extension RoomType: Equatable {
    static func == (lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}
