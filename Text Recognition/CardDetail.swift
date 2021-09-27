//
//  CardDetail.swift
//  CardScanDemo
//
//  Created by Manali on 22/09/21.
//


import Foundation


class CardDetail
{
    
    var CardName: String = ""
    var CardNumber: String = ""
    var CardExp: String = ""
    var id:String = ""
    init(id:String, CardName:String, CardNumber:String , CardExp:String)
    {
        self.id = id
        self.CardName = CardName
        self.CardNumber = CardNumber
        self.CardExp = CardExp
      
    }
    
}
