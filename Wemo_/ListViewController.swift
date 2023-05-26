//
//  ListViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/07.
//

import UIKit
import SQLite3

class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var label_name: UILabel!
    
    @IBOutlet var label_shape: UILabel!
    
    @IBOutlet var label_color: UILabel!
    
    @IBOutlet var label_formulation: UILabel!
    
    @IBOutlet var label_dividingLine: UILabel!
    
    @IBOutlet var label_print: UILabel!
    
    @IBOutlet var label_etcOtcName: UILabel!
    
    @IBOutlet var label_enptName: UILabel!
    
    @IBOutlet var tableview: UITableView!
    
    var str_label_name : String = ""
    var str_label_shape : String = ""
    var str_label_color : String = ""
    var str_label_formulation : String = ""
    var str_label_dividingLine : String = ""
    var str_label_print : String = ""
    var str_label_etcOtcName : String = ""
    var str_label_enptName : String = ""
    
    
    
    var conditional:String = ""
    
    let dbHelper = DBHelper.shared
    var dataArray: [MyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setTextLabel()
        initSet()
        
        start()

        tableview.delegate=self
        tableview.dataSource=self
        
        tableview.rowHeight = 200
        
        
        
    }//end of viewDidLoad
    
//    func start(){
//        self.dataArray = dbHelper.readData()
//        self.tableview.reloadData()
//        print(dataArray.count)
//    }//end of start

    
    func start(){
        
        if label_name.text == "이름 및 명칭" && label_shape.text == "모양" && label_color.text == "색상" && label_formulation.text == "제형" && label_dividingLine.text == "분할선" && label_print.text == "마크" && label_etcOtcName.text == "구분" && label_enptName.text == "업체"{
            
            self.dataArray = dbHelper.readData() // not select
            
        }else{
            if label_name.text != "이름 및 명칭"{
                conditional += "ITEM_NAME LIKE \"%"+label_name.text!+"%\""

                if label_shape.text != "모양" || label_color.text != "색상" || label_formulation.text != "제형" || label_dividingLine.text != "분할선" || label_print.text != "마크" || label_etcOtcName.text != "구분" || label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if

            }//end of if

            if label_shape.text != "모양" {
                conditional += "DRUG_SHAPE = \""+label_shape.text!+"\""

                if label_color.text != "색상" || label_formulation.text != "제형" || label_dividingLine.text != "분할선" || label_print.text != "마크" || label_etcOtcName.text != "구분" || label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if

            }//end of if


            if label_color.text != "색상" {
                conditional+="(COLOR_CLASS1 LIKE \"%"+label_color.text!+"%\" OR COLOR_CLASS2 LIKE \"%"+label_color.text!+"%\")"

                if label_formulation.text != "제형" || label_dividingLine.text != "분할선" || label_print.text != "마크" || label_etcOtcName.text != "구분" || label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if

            }//end of if


            if label_formulation.text != "제형" {
                conditional += "FORM_CODE_NAME_CATEGORY = \""+label_formulation.text!+"\""

                if label_dividingLine.text != "분할선" || label_print.text != "마크" || label_etcOtcName.text != "구분" || label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if

            }//end of if
            
            
            if label_dividingLine.text != "분할선" {
                var str : String = "-"
                
                if label_dividingLine.text == "기타"{
                    str = "기타"
                }else if label_dividingLine.text == "(+)형"{
                    str = "+"
                }//end of if
                
                conditional += "(LINE_FRONT = \""+str+"\" OR LINE_BACK = \""+str+"\")"
                
                if label_print.text != "마크" || label_etcOtcName.text != "구분" || label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if
                
            }//end of if
            
            
            if label_print.text != "마크"{
                conditional += "(PRINT_FRONT = \""+label_print.text!+"\" OR PRINT_BACK = \""+label_print.text!+"\")"
                
                if label_etcOtcName.text != "구분" || label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if
                
            }//end of if
            
            if label_etcOtcName.text != "구분"{
                conditional += "ETC_OTC_NAME = \""+label_etcOtcName.text!+"\""
                
                if label_enptName.text != "업체"{
                    conditional+=" AND "
                }//end of if
                
            }//end of if
            
            if label_enptName.text != "업체"{
                conditional += " ENTP_NAME = \""+label_enptName.text!+"\""
            }//end of if
            
            self.dataArray = dbHelper.readSelectData(conditional: conditional) // select
        }//end of else if

        self.tableview.reloadData()
        print(dataArray.count)
    }//end of start
    
    func initSet(){
        setLabel(label: label_name)
        setLabel(label: label_shape)
        setLabel(label: label_color)
        setLabel(label: label_formulation)
        setLabel(label: label_dividingLine)
        setLabel(label: label_print)
        setLabel(label: label_etcOtcName)
        setLabel(label: label_enptName)
    }//end of initSet
    
    func setLabel(label : UILabel){
        
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        
        if label.text == "이름 및 명칭" || label.text == "모양" || label.text == "색상" || label.text == "제형" || label.text == "분할선" || label.text == "마크" || label.text == "구분" || label.text == "업체"{
            label.textColor = UIColor.lightGray
        }else{
            label.textColor = UIColor.black
        }//end of else if
        
    }//end of setLabel
    
    func setTextLabel(){
        
        if str_label_name == ""{
            label_name.text = "이름 및 명칭"
        }else{
            label_name.text = str_label_name
        }//end of else if 
    
        label_shape.text = str_label_shape
        label_color.text = str_label_color
        label_formulation.text = str_label_formulation
        label_dividingLine.text = str_label_dividingLine
        label_print.text = str_label_print
        label_etcOtcName.text = str_label_etcOtcName
        label_enptName.text = str_label_enptName
    }//end of setTextLabel
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }//end of tableview count
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        let url = URL(string: String(dataArray[indexPath.row].ITEM_IMAGE))
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.img_itemImage.image = UIImage(data: data!)
            }//end of main
        }//end of global
        
        cell.btn_name.setTitle(String(dataArray[indexPath.row].ITEM_NAME), for: .normal)
        
        cell.label_shape.text = String(dataArray[indexPath.row].DRUG_SHAPE)
        
        cell.label_color.text = String(dataArray[indexPath.row].COLOR_CLASS1+" | "+dataArray[indexPath.row].COLOR_CLASS2)
        
        cell.label_formulation.text = String(dataArray[indexPath.row].FORM_CODE_NAME_CATEGORY)
        
        cell.label_dividingLine.text = String(dataArray[indexPath.row].LINE_FRONT+" | "+dataArray[indexPath.row].LINE_BACK)
        
        cell.label_print.text = String(dataArray[indexPath.row].PRINT_FRONT+" | "+dataArray[indexPath.row].PRINT_BACK)
        
        cell.label_etcOtcName.text = String(dataArray[indexPath.row].ETC_OTC_NAME)
        
        cell.label_entpName.text = String(dataArray[indexPath.row].ENTP_NAME)
        
        cell.label_className.text = String(dataArray[indexPath.row].CLASS_NAME)

        return cell
    }//end of tableview cell
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfoSegue"{
            if let destination = segue.destination as?
                MoreInfoViewController {
                if let selectdeIndex =
                    self.tableview.indexPathForSelectedRow?.row {
                        
                    destination.str_img_itemImg = dataArray[selectdeIndex].ITEM_IMAGE
                    destination.str_label_name = dataArray[selectdeIndex].ITEM_NAME
                    destination.str_label_shape = dataArray[selectdeIndex].DRUG_SHAPE
                    destination.str_label_color = dataArray[selectdeIndex].COLOR_CLASS1+" | "+dataArray[selectdeIndex].COLOR_CLASS2
                    destination.str_label_formulation = dataArray[selectdeIndex].FORM_CODE_NAME_CATEGORY
                    destination.str_label_dividingLine = dataArray[selectdeIndex].LINE_FRONT+" | "+dataArray[selectdeIndex].LINE_BACK
                    destination.str_label_print = dataArray[selectdeIndex].PRINT_FRONT+" | "+dataArray[selectdeIndex].PRINT_BACK
                    destination.str_label_etcOtcName = dataArray[selectdeIndex].ETC_OTC_NAME
                    destination.str_label_enptName=dataArray[selectdeIndex].ENTP_NAME
                    destination.str_label_className = dataArray[selectdeIndex].CLASS_NAME
                    
                    
                }//end of if
            }//end of MoreInfoViewController
        }//end of if
    }//end of prepare
    

}//end of class
