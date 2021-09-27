//
//  Database.swift
//  CardScanDemo
//
//  Created by Manali on 22/09/21.
//

import Foundation

import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
        
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    func createTable(){
        let createTableString = "CREATE TABLE IF NOT EXISTS CardDetail(Id INTEGER PRIMARY KEY,Cardname TEXT ,Cardnumber TEXT,CardExp TEXT );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("CardDetail table created.")
            } else {
                print("CardDetail table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
   
    func insert(id:Int, Cardname:String, Cardnumber:String , CardExp:String) {
        let cardDetail = read()
        for p in cardDetail
        {
            if p.CardNumber == Cardnumber
            {
                return
                    Update(CardNumber: Cardnumber,Cardname:Cardname,CardExp:CardExp)
            }
        }
        print(Cardname)
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO CardDetail (Id, Cardname, Cardnumber,CardExp) VALUES (NULL, ?,?,?);"
       

        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
         
              sqlite3_bind_text(insertStatement, 1, (Cardname as NSString).utf8String, -1, nil)
                          sqlite3_bind_text(insertStatement, 3, (CardExp as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (Cardnumber as NSString).utf8String, -1, nil)
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row")
                    read()
                } else {
                    print("Could not insert row")
                }
                sqlite3_reset(insertStatement)
           // }
            sqlite3_finalize(insertStatement)
        } else {
            print("INSERT statement could not be prepared.")
        }
        
      
    }
    

   
    func read() -> [CardDetail] {
        let queryStatementString = "SELECT * FROM CardDetail;"
        var queryStatement: OpaquePointer? = nil
        var psns : [CardDetail] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id =  String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                               let Cardname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let CardExp = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let CardNumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
             
                psns.append(CardDetail(id: "0", CardName: Cardname, CardNumber: CardNumber, CardExp: CardExp))
                               print("Query Result Read:")
                               print("\(id) | \(Cardname) | \(CardNumber) | \(CardExp) ")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
 
  
   var serviceCount = String()
  var arr = [String]()
    var arroComboService = [String]()
    var arroCombo = [String]()
    var arroUpgrade = [String]()
    var arroUpgradeCount = [String]()
    var arroAddOn = [String]()
    var arroAddservice = [String]()
    var arroComboID = String()
    var arroComboID1 = [String]()
    var arroComboPrice = [String]()
    var arroComboCount = [String]()
    var arroComboServiceCount = String()
    var arroComboIDfinal = String()
    func SelectCard(CardNumber:String)
    {
   
           let queryStatementString = "SELECT CardNumber FROM CardDetail WHERE CardNumber ='\(CardNumber)';"
               var queryStatement: OpaquePointer? = nil
               var psns : [CardDetail] = []
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                   while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
                 
                    arroAddservice.append(String(id))
                  
                    UserDefaults.standard.set("\(CardNumber)", forKey: "SelectResult")
                   }
              
               }
               else
               {
                   print("SELECT statement could not be prepared")
             
               }
       print(arr)
               sqlite3_finalize(queryStatement)
              
       }
    var counrArr = [String]()
   
          
    func   Update(CardNumber: String,Cardname:String,CardExp:String){
     
    
      
      let updateStatementString = "UPDATE CardDetail SET Cardname ='\(Cardname)'WHERE CardNumber ='\(CardNumber)' ;"
      var updateStatement: OpaquePointer? = nil
      if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
          
          
             if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated row.")
             } else {
                    print("Could not update row.")
             }
           } else {
                 print("UPDATE statement could not be prepared")
           }
      
           sqlite3_finalize(updateStatement)
      
       }
  
    
    func DeleteRowDatabase(CardNumber : String) -> Bool {
      var deleteStatement: OpaquePointer? = nil
        var returnCode : Bool = false
 var deleteStatementString : String = "delete from CardDetail where CardNumber = ?"
       if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            print("Successfully opened connection to database at ")

            // step 16d - setup query - entries is the table name you created in step 0
            var deleteStatement: OpaquePointer? = nil
           

            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
               sqlite3_bind_text(deleteStatement, 1, CardNumber, -1, nil)
                if sqlite3_step(deleteStatement) == SQLITE_DONE  {
                    returnCode = true
                }

                sqlite3_finalize(deleteStatement)
            }
        }

        sqlite3_close(db)

        return returnCode

    }

}
