//
//  DBHelper.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/07.
//
struct MyModel: Codable {
    var ITEM_SEQ : String
    var ITEM_NAME : String
    var ENTP_NAME : String
    var ITEM_IMAGE : String
    var PRINT_FRONT : String
    var PRINT_BACK : String
    var DRUG_SHAPE : String
    var COLOR_CLASS1 : String
    var COLOR_CLASS2 : String
    var LINE_FRONT : String
    var LINE_BACK : String
    var CLASS_NAME : String
    var ETC_OTC_NAME : String
    var FORM_CODE_NAME_CATEGORY : String
}//end of MyModel


struct MoreInfo : Codable{
    var ITEM_SEQ_MI : String
    var ITEM_NAME_MI : String
    var ENTP_NAME_MI : String
    var MAIN_INGREDIENT : String
    var EFCY_QESITEM : String
    var USE_METHOD_QESITM : String
    var ATPN_WARN_QESITM : String
    var ATPN_QESITM : String
    var INTRC_QESITM : String
    var SE_QESITM : String
    var DEPOSIT_METHOD_QESITM : String
    var OPEN_DE : String
    var UPDATE_DE : String
    var BIZRNO : String
}//end of MoreInfo

struct SelectItemName:Codable{
    var ITEM_NAME_SElECT : String
    var ETC_OTC_NAME_SElECT : String
}//end of

struct Prescription : Codable{
    var SERVICE_NAME : String
    var BUSINESS_STATUS_CODE : String
    var BUSINESS_STATUS_NAME : String
    var COMPANY_PHONE_NUMBER : String
    var COMPANY_POSTAL_ADDRESS : String
    var COMPANY_ALL_ADDRESS : String
    var COMPANY_ROAD_NAME_ADDRESS : String
    var COMPANY_ROAD_NAME_POSTAL_ADDRESS : String
    var COMPANY_NAME : String
    var COMPANY_LOCATION_X : Double
    var COMPANY_LOCATION_Y : Double
}//end of Prescription

struct LatXLngY {
    var lat: Double
    var lng: Double
    var x: Int
    var y: Int
}//end of LatXLngY

import Foundation


class DBHelper{
    
    static let shared = DBHelper()
    
    //MyModel
    var ITEM_SEQ : String! = ""
    var ITEM_NAME : String! = ""
    var ENTP_NAME : String! = ""
    var ITEM_IMAGE : String! = ""
    var PRINT_FRONT : String! = ""
    var PRINT_BACK : String! = ""
    var DRUG_SHAPE : String! = ""
    var COLOR_CLASS1 : String! = ""
    var COLOR_CLASS2 : String! = ""
    var LINE_FRONT : String! = ""
    var LINE_BACK : String! = ""
    var CLASS_NAME : String! = ""
    var ETC_OTC_NAME : String! = ""
    var FORM_CODE_NAME_CATEGORY : String! = ""
    
    
    //MoreInfo
    var ITEM_SEQ_MI : String! = ""
    var ITEM_NAME_MI : String! = ""
    var ENTP_NAME_MI : String! = ""
    var MAIN_INGREDIENT : String! = ""
    var EFCY_QESITEM : String! = ""
    var USE_METHOD_QESITM : String! = ""
    var ATPN_WARN_QESITM : String! = ""
    var ATPN_QESITM : String! = ""
    var INTRC_QESITM : String! = ""
    var SE_QESITM : String! = ""
    var DEPOSIT_METHOD_QESITM : String! = ""
    var OPEN_DE : String! = ""
    var UPDATE_DE : String! = ""
    var BIZRNO : String! = ""
    
    //SelectItemName
    var ITEM_NAME_SElECT : String = ""
    var ETC_OTC_NAME_SElECT : String = ""
    
    //Prescription
    var SERVICE_NAME : String! = ""
    var BUSINESS_STATUS_CODE : String! = ""
    var BUSINESS_STATUS_NAME : String! = ""
    var COMPANY_PHONE_NUMBER : String! = ""
    var COMPANY_POSTAL_ADDRESS : String! = ""
    var COMPANY_ALL_ADDRESS : String! = ""
    var COMPANY_ROAD_NAME_ADDRESS : String! = ""
    var COMPANY_ROAD_NAME_POSTAL_ADDRESS : String! = ""
    var COMPANY_NAME : String! = ""
    var COMPANY_LOCATION_X : Double! = 0.0
    var COMPANY_LOCATION_Y : Double! = 0.0
    
    //Coordinate Transformation
    let TO_GPS_FROM_GRID = 2
    let TO_GRID = 1
    let TO_GPS = 2
    
        
    var db : OpaquePointer? //db를 가리키는 포인터
    // db 이름은 항상 "DB이름.sqlite" 형식으로 해줄 것.
    let databaseName = "MedicinesDB.sqlite"
    
    init(){
        self.db = getDBPath()
    }//end of init

    deinit {
        sqlite3_close(db)
    }//end of deinit
    
    func getDBPath() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        /// 파일매니저객체 -> 앱 내의 디렉토리 탐색 -> "db.sqlite"파일의 디렉토리 획득
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("MedicinesDB.sqlite").path
        
        /// 파일이 없다면 앱 번들에 만들어 놓은 db.sqlite가져와서 사용
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "MedicinesDB", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }//end of if
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully connect DB. Path: \(dbPath)")
            return db
        }//end of sqlite3_open
        
        print("DB Path : ",dbPath)
    
        return nil
        
    }//end of getDBPath
    
    func readData() -> [MyModel] {
            let query: String = "SELECT * from Medicines_Basic_Info_edit_process;"
            var stmt: OpaquePointer? = nil
            // 아래는 [MyModel]? 이 되면 값이 안 들어감
            // Nil을 인식하지 못하는 것으로..ㅎ
            var result: [MyModel] = []

            if sqlite3_prepare(self.db, query, -1, &stmt, nil) != SQLITE_OK {
                let errorMessage = String(cString: sqlite3_errmsg(db)!)
                print("error while prepare: \(errorMessage)")
                return result
            }//end of if
        
            print(query)
        
            while sqlite3_step(stmt) == SQLITE_ROW {
                
                if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                   ITEM_SEQ  = String(cString: sqlite3_column_text(stmt, 0))
                } else {
                    ITEM_SEQ = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 1) != SQLITE_NULL {
                    ITEM_NAME = String(cString: sqlite3_column_text(stmt, 1))
                } else {
                    ITEM_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 2) != SQLITE_NULL {
                    ENTP_NAME = String(cString: sqlite3_column_text(stmt, 2))
                } else {
                    ENTP_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 3) != SQLITE_NULL {
                    ITEM_IMAGE = String(cString: sqlite3_column_text(stmt, 3))
                } else {
                    ITEM_IMAGE = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 4) != SQLITE_NULL {
                    PRINT_FRONT = String(cString: sqlite3_column_text(stmt, 4))
                } else {
                    PRINT_FRONT = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 5) != SQLITE_NULL {
                    PRINT_BACK = String(cString: sqlite3_column_text(stmt, 5))
                } else {
                    PRINT_BACK = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 6) != SQLITE_NULL {
                    DRUG_SHAPE = String(cString: sqlite3_column_text(stmt, 6))
                } else {
                    DRUG_SHAPE = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 7) != SQLITE_NULL {
                    COLOR_CLASS1 = String(cString: sqlite3_column_text(stmt, 7))
                } else {
                    COLOR_CLASS1 = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 8) != SQLITE_NULL {
                    COLOR_CLASS2 = String(cString: sqlite3_column_text(stmt, 8))
                } else {
                    COLOR_CLASS2 = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 9) != SQLITE_NULL {
                    LINE_FRONT = String(cString: sqlite3_column_text(stmt, 9))
                } else {
                    LINE_FRONT = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 10) != SQLITE_NULL {
                    LINE_BACK = String(cString: sqlite3_column_text(stmt, 10))
                } else {
                    LINE_BACK = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 11) != SQLITE_NULL {
                    CLASS_NAME = String(cString: sqlite3_column_text(stmt, 11))
                } else {
                    CLASS_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 12) != SQLITE_NULL {
                    ETC_OTC_NAME = String(cString: sqlite3_column_text(stmt, 12))
                } else {
                    ETC_OTC_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 13) != SQLITE_NULL {
                    FORM_CODE_NAME_CATEGORY = String(cString: sqlite3_column_text(stmt, 13))
                } else {
                    FORM_CODE_NAME_CATEGORY = " "
                }//end of if
                           
                result.append(MyModel(ITEM_SEQ: ITEM_SEQ, ITEM_NAME: ITEM_NAME, ENTP_NAME: ENTP_NAME, ITEM_IMAGE: ITEM_IMAGE, PRINT_FRONT: PRINT_FRONT, PRINT_BACK: PRINT_BACK, DRUG_SHAPE: DRUG_SHAPE, COLOR_CLASS1: COLOR_CLASS1, COLOR_CLASS2: COLOR_CLASS2, LINE_FRONT: LINE_FRONT, LINE_BACK: LINE_BACK, CLASS_NAME: CLASS_NAME, ETC_OTC_NAME: ETC_OTC_NAME, FORM_CODE_NAME_CATEGORY: FORM_CODE_NAME_CATEGORY))
            }//end of while
        
            sqlite3_finalize(stmt) //출력하고 싶은데
            
            return result
        }//end of readData
    
    func readSelectData(conditional:String) -> [MyModel] {
            let query: String = "select * from Medicines_Basic_Info_edit_process where "
            let finalQuery = query+conditional+";"
            var stmt: OpaquePointer? = nil
            // 아래는 [MyModel]? 이 되면 값이 안 들어감
            // Nil을 인식하지 못하는 것으로.. ㅎ
            var result: [MyModel] = []

            if sqlite3_prepare(self.db, finalQuery, -1, &stmt, nil) != SQLITE_OK {
                let errorMessage = String(cString: sqlite3_errmsg(db)!)
                print("error while prepare: \(errorMessage)")
                return result
            }//end of if
        
            print(finalQuery)
        
            while sqlite3_step(stmt) == SQLITE_ROW {
                
                if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                   ITEM_SEQ  = String(cString: sqlite3_column_text(stmt, 0))
                } else {
                    ITEM_SEQ = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 1) != SQLITE_NULL {
                    ITEM_NAME = String(cString: sqlite3_column_text(stmt, 1))
                } else {
                    ITEM_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 2) != SQLITE_NULL {
                    ENTP_NAME = String(cString: sqlite3_column_text(stmt, 2))
                } else {
                    ENTP_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 3) != SQLITE_NULL {
                    ITEM_IMAGE = String(cString: sqlite3_column_text(stmt, 3))
                } else {
                    ITEM_IMAGE = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 4) != SQLITE_NULL {
                    PRINT_FRONT = String(cString: sqlite3_column_text(stmt, 4))
                } else {
                    PRINT_FRONT = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 5) != SQLITE_NULL {
                    PRINT_BACK = String(cString: sqlite3_column_text(stmt, 5))
                } else {
                    PRINT_BACK = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 6) != SQLITE_NULL {
                    DRUG_SHAPE = String(cString: sqlite3_column_text(stmt, 6))
                } else {
                    DRUG_SHAPE = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 7) != SQLITE_NULL {
                    COLOR_CLASS1 = String(cString: sqlite3_column_text(stmt, 7))
                } else {
                    COLOR_CLASS1 = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 8) != SQLITE_NULL {
                    COLOR_CLASS2 = String(cString: sqlite3_column_text(stmt, 8))
                } else {
                    COLOR_CLASS2 = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 9) != SQLITE_NULL {
                    LINE_FRONT = String(cString: sqlite3_column_text(stmt, 9))
                } else {
                    LINE_FRONT = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 10) != SQLITE_NULL {
                    LINE_BACK = String(cString: sqlite3_column_text(stmt, 10))
                } else {
                    LINE_BACK = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 11) != SQLITE_NULL {
                    CLASS_NAME = String(cString: sqlite3_column_text(stmt, 11))
                } else {
                    CLASS_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 12) != SQLITE_NULL {
                    ETC_OTC_NAME = String(cString: sqlite3_column_text(stmt, 12))
                } else {
                    ETC_OTC_NAME = " "
                }//end of if
                
                if sqlite3_column_type(stmt, 13) != SQLITE_NULL {
                    FORM_CODE_NAME_CATEGORY = String(cString: sqlite3_column_text(stmt, 13))
                } else {
                    FORM_CODE_NAME_CATEGORY = " "
                }//end of if
                           
                result.append(MyModel(ITEM_SEQ: ITEM_SEQ, ITEM_NAME: ITEM_NAME, ENTP_NAME: ENTP_NAME, ITEM_IMAGE: ITEM_IMAGE, PRINT_FRONT: PRINT_FRONT, PRINT_BACK: PRINT_BACK, DRUG_SHAPE: DRUG_SHAPE, COLOR_CLASS1: COLOR_CLASS1, COLOR_CLASS2: COLOR_CLASS2, LINE_FRONT: LINE_FRONT, LINE_BACK: LINE_BACK, CLASS_NAME: CLASS_NAME, ETC_OTC_NAME: ETC_OTC_NAME, FORM_CODE_NAME_CATEGORY: FORM_CODE_NAME_CATEGORY))
            }//end of while
        
            sqlite3_finalize(stmt)
            
            return result
        }//end of readSelectData
    
    func readSelectDataItemName(conditional:String) -> [SelectItemName] {
            let query: String = "SELECT ETC_OTC_NAME from Medicines_Basic_Info_edit where "
            let finalQuery = query+conditional+";"
            var stmt: OpaquePointer? = nil
            // 아래는 [MyModel]? 이 되면 값이 안 들어감
            // Nil을 인식하지 못하는 것으로.. ㅎ
            var result: [SelectItemName] = []

            if sqlite3_prepare(self.db, finalQuery, -1, &stmt, nil) != SQLITE_OK {
                let errorMessage = String(cString: sqlite3_errmsg(db)!)
                print("error while prepare: \(errorMessage)")
                return result
            }//end of if
        
            print(finalQuery)
        
            while sqlite3_step(stmt) == SQLITE_ROW {
                
                if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                    ITEM_NAME_SElECT = String(cString: sqlite3_column_text(stmt, 0))
                } else {
                    ITEM_NAME_SElECT = " "
                }//end of if
                if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                    ETC_OTC_NAME_SElECT = String(cString: sqlite3_column_text(stmt, 0))
                } else {
                    ETC_OTC_NAME_SElECT = " "
                }//end of if
                
                result.append(SelectItemName(ITEM_NAME_SElECT: ITEM_NAME_SElECT, ETC_OTC_NAME_SElECT: ETC_OTC_NAME_SElECT))
            }//end of while
        
            sqlite3_finalize(stmt)
            
            return result
        }//end of readSelectData
    
    func readMoreInfoData(conditional:String) -> [MoreInfo] {
        let query: String = "SELECT * from Medicines_Usage_Info WHERE ITEM_SEQ = (SELECT ITEM_SEQ from Medicines_Basic_Info_edit_process WHERE ITEM_NAME= \""
        let finalQuery = query+conditional+"\");"
        var stmt: OpaquePointer? = nil
        var result: [MoreInfo] = []

        if sqlite3_prepare(self.db, finalQuery, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }//end of if
    
        print(finalQuery)
    
        while sqlite3_step(stmt) == SQLITE_ROW {
            
            if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                ITEM_SEQ_MI  = String(cString: sqlite3_column_text(stmt, 0))
            } else {
                ITEM_SEQ_MI = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 1) != SQLITE_NULL {
                ITEM_NAME_MI = String(cString: sqlite3_column_text(stmt, 1))
            } else {
                ITEM_NAME_MI = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 2) != SQLITE_NULL {
                ENTP_NAME_MI = String(cString: sqlite3_column_text(stmt, 2))
            } else {
                ENTP_NAME_MI = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 3) != SQLITE_NULL {
                MAIN_INGREDIENT = String(cString: sqlite3_column_text(stmt, 3))
            } else {
                MAIN_INGREDIENT = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 4) != SQLITE_NULL {
                EFCY_QESITEM = String(cString: sqlite3_column_text(stmt, 4))
            } else {
                EFCY_QESITEM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 5) != SQLITE_NULL {
                USE_METHOD_QESITM = String(cString: sqlite3_column_text(stmt, 5))
            } else {
                USE_METHOD_QESITM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 6) != SQLITE_NULL {
                ATPN_WARN_QESITM = String(cString: sqlite3_column_text(stmt, 6))
            } else {
                ATPN_WARN_QESITM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 7) != SQLITE_NULL {
                ATPN_QESITM = String(cString: sqlite3_column_text(stmt, 7))
            } else {
                ATPN_QESITM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 8) != SQLITE_NULL {
                INTRC_QESITM = String(cString: sqlite3_column_text(stmt, 8))
            } else {
                INTRC_QESITM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 9) != SQLITE_NULL {
                SE_QESITM = String(cString: sqlite3_column_text(stmt, 9))
            } else {
                SE_QESITM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 10) != SQLITE_NULL {
                DEPOSIT_METHOD_QESITM = String(cString: sqlite3_column_text(stmt, 10))
            } else {
                DEPOSIT_METHOD_QESITM = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 11) != SQLITE_NULL {
                OPEN_DE = String(cString: sqlite3_column_text(stmt, 11))
            } else {
                OPEN_DE = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 12) != SQLITE_NULL {
                UPDATE_DE = String(cString: sqlite3_column_text(stmt, 12))
            } else {
                UPDATE_DE = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 13) != SQLITE_NULL {
                BIZRNO = String(cString: sqlite3_column_text(stmt, 13))
            } else {
                BIZRNO = " "
            }//end of if
                       
            result.append(MoreInfo(ITEM_SEQ_MI: ITEM_SEQ_MI, ITEM_NAME_MI: ITEM_NAME_MI, ENTP_NAME_MI: ENTP_NAME_MI, MAIN_INGREDIENT: MAIN_INGREDIENT, EFCY_QESITEM: EFCY_QESITEM, USE_METHOD_QESITM: USE_METHOD_QESITM, ATPN_WARN_QESITM: ATPN_WARN_QESITM, ATPN_QESITM: ATPN_QESITM, INTRC_QESITM: INTRC_QESITM, SE_QESITM: SE_QESITM, DEPOSIT_METHOD_QESITM: SE_QESITM, OPEN_DE: OPEN_DE, UPDATE_DE: UPDATE_DE, BIZRNO: BIZRNO))
        }//end of while
    
        sqlite3_finalize(stmt)
        
        return result
    }//end of readMoreInfoData
    
    func readPrescriptionDataAll() -> [Prescription] {
        let query: String = "select * from Store_Prescription_Drug_edit UNION ALL select * from Store_Non_Prescription_Drug_edit;"
        var stmt: OpaquePointer? = nil
        var result: [Prescription] = []

        if sqlite3_prepare(self.db, query, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }//end of if
    
        print(query)
    
        while sqlite3_step(stmt) == SQLITE_ROW {
            
            if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                SERVICE_NAME  = String(cString: sqlite3_column_text(stmt, 0))
            } else {
                SERVICE_NAME = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 1) != SQLITE_NULL {
                BUSINESS_STATUS_CODE = String(cString: sqlite3_column_text(stmt, 1))
            } else {
                BUSINESS_STATUS_CODE = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 2) != SQLITE_NULL {
                BUSINESS_STATUS_NAME = String(cString: sqlite3_column_text(stmt, 2))
            } else {
                BUSINESS_STATUS_NAME = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 3) != SQLITE_NULL {
                COMPANY_PHONE_NUMBER = String(cString: sqlite3_column_text(stmt, 3))
            } else {
                COMPANY_PHONE_NUMBER = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 4) != SQLITE_NULL {
                COMPANY_POSTAL_ADDRESS = String(cString: sqlite3_column_text(stmt, 4))
            } else {
                COMPANY_POSTAL_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 5) != SQLITE_NULL {
                COMPANY_ALL_ADDRESS = String(cString: sqlite3_column_text(stmt, 5))
            } else {
                COMPANY_ALL_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 6) != SQLITE_NULL {
                COMPANY_ROAD_NAME_ADDRESS = String(cString: sqlite3_column_text(stmt, 6))
            } else {
                COMPANY_ROAD_NAME_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 7) != SQLITE_NULL {
                COMPANY_ROAD_NAME_POSTAL_ADDRESS = String(cString: sqlite3_column_text(stmt, 7))
            } else {
                COMPANY_ROAD_NAME_POSTAL_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 8) != SQLITE_NULL {
                COMPANY_NAME = String(cString: sqlite3_column_text(stmt, 8))
            } else {
                COMPANY_NAME = " "
            }//end of if
            
            if let columnValue = sqlite3_column_text(stmt, 9) {
                let stringValue = String(cString: columnValue)
                COMPANY_LOCATION_X = Double(stringValue) ?? 0.0
            } else {
                COMPANY_LOCATION_X = 0.0
            }//end of else if
            
            if let columnValue = sqlite3_column_text(stmt, 10) {
                let stringValue = String(cString: columnValue)
                COMPANY_LOCATION_Y = Double(stringValue) ?? 0.0
            } else {
                COMPANY_LOCATION_Y = 0.0
            }//end of else if

            result.append(Prescription(SERVICE_NAME: SERVICE_NAME, BUSINESS_STATUS_CODE: BUSINESS_STATUS_CODE, BUSINESS_STATUS_NAME: BUSINESS_STATUS_NAME, COMPANY_PHONE_NUMBER: COMPANY_PHONE_NUMBER, COMPANY_POSTAL_ADDRESS: COMPANY_POSTAL_ADDRESS, COMPANY_ALL_ADDRESS: COMPANY_ALL_ADDRESS, COMPANY_ROAD_NAME_ADDRESS: COMPANY_ROAD_NAME_ADDRESS, COMPANY_ROAD_NAME_POSTAL_ADDRESS: COMPANY_ROAD_NAME_POSTAL_ADDRESS, COMPANY_NAME: COMPANY_NAME, COMPANY_LOCATION_X: COMPANY_LOCATION_X, COMPANY_LOCATION_Y: COMPANY_LOCATION_Y))
            
        }//end of while
    
        sqlite3_finalize(stmt)
        
        return result
    }//end of readPrescriptionDataAll
    
    func readPrescriptionData(conditional:String) -> [Prescription] {
        let query1: String = "select * from Store_Prescription_Drug_edit where "
        let query2: String = "select * from Store_Non_Prescription_Drug_edit where "
        let finalQuery = query1+conditional+" and BUSINESS_STATUS_CODE=1 UNION ALL "+query2+conditional+" and BUSINESS_STATUS_CODE=1;"
        var stmt: OpaquePointer? = nil
        var result: [Prescription] = []
        
        if sqlite3_prepare(self.db, finalQuery, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }//end of if
        
        print(finalQuery)
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            
            if sqlite3_column_type(stmt, 0) != SQLITE_NULL {
                SERVICE_NAME  = String(cString: sqlite3_column_text(stmt, 0))
            } else {
                SERVICE_NAME = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 1) != SQLITE_NULL {
                BUSINESS_STATUS_CODE = String(cString: sqlite3_column_text(stmt, 1))
            } else {
                BUSINESS_STATUS_CODE = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 2) != SQLITE_NULL {
                BUSINESS_STATUS_NAME = String(cString: sqlite3_column_text(stmt, 2))
            } else {
                BUSINESS_STATUS_NAME = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 3) != SQLITE_NULL {
                COMPANY_PHONE_NUMBER = String(cString: sqlite3_column_text(stmt, 3))
            } else {
                COMPANY_PHONE_NUMBER = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 4) != SQLITE_NULL {
                COMPANY_POSTAL_ADDRESS = String(cString: sqlite3_column_text(stmt, 4))
            } else {
                COMPANY_POSTAL_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 5) != SQLITE_NULL {
                COMPANY_ALL_ADDRESS = String(cString: sqlite3_column_text(stmt, 5))
            } else {
                COMPANY_ALL_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 6) != SQLITE_NULL {
                COMPANY_ROAD_NAME_ADDRESS = String(cString: sqlite3_column_text(stmt, 6))
            } else {
                COMPANY_ROAD_NAME_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 7) != SQLITE_NULL {
                COMPANY_ROAD_NAME_POSTAL_ADDRESS = String(cString: sqlite3_column_text(stmt, 7))
            } else {
                COMPANY_ROAD_NAME_POSTAL_ADDRESS = " "
            }//end of if
            
            if sqlite3_column_type(stmt, 8) != SQLITE_NULL {
                COMPANY_NAME = String(cString: sqlite3_column_text(stmt, 8))
            } else {
                COMPANY_NAME = " "
            }//end of if
            
            if let columnValue = sqlite3_column_text(stmt, 9) {
                let stringValue = String(cString: columnValue)
                COMPANY_LOCATION_X = Double(stringValue) ?? 0.0
            } else {
                COMPANY_LOCATION_X = 0.0
                
            }//end of else if
            
            if let columnValue = sqlite3_column_text(stmt, 10) {
                let stringValue = String(cString: columnValue)
                COMPANY_LOCATION_Y = Double(stringValue) ?? 0.0
            } else {
                COMPANY_LOCATION_Y = 0.0
            }//end of else if
            
            result.append(Prescription(SERVICE_NAME: SERVICE_NAME, BUSINESS_STATUS_CODE: BUSINESS_STATUS_CODE, BUSINESS_STATUS_NAME: BUSINESS_STATUS_NAME, COMPANY_PHONE_NUMBER: COMPANY_PHONE_NUMBER, COMPANY_POSTAL_ADDRESS: COMPANY_POSTAL_ADDRESS, COMPANY_ALL_ADDRESS: COMPANY_ALL_ADDRESS, COMPANY_ROAD_NAME_ADDRESS: COMPANY_ROAD_NAME_ADDRESS, COMPANY_ROAD_NAME_POSTAL_ADDRESS: COMPANY_ROAD_NAME_POSTAL_ADDRESS, COMPANY_NAME: COMPANY_NAME, COMPANY_LOCATION_X: COMPANY_LOCATION_X, COMPANY_LOCATION_Y: COMPANY_LOCATION_Y))
            
        }//end of while
        
        sqlite3_finalize(stmt)
        
        return result
    }//end of readPrescriptionData
    

    
}//end of class
