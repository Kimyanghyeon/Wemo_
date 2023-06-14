//
//  MoreInfoViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/10.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    
    
    @IBOutlet var img_itemImage: UIImageView!
    
    @IBOutlet var label_name: UILabel!
    
    @IBOutlet var label_shape: UILabel!
    
    @IBOutlet var label_color: UILabel!
    
    @IBOutlet var label_formulation: UILabel!
    
    @IBOutlet var label_dividingLine: UILabel!
    
    @IBOutlet var label_print: UILabel!
    
    @IBOutlet var label_etcOtcName: UILabel!
    
    @IBOutlet var label_entpName: UILabel!
    
    @IBOutlet var label_className: UILabel!
    
    
    @IBOutlet var label_main_ingredient: UILabel!
    
    @IBOutlet var label_efcy_qesitem: UILabel!
    
    @IBOutlet var label_use_method_qesitm: UILabel!
    
    @IBOutlet var label_atpn_warn_qesitm: UILabel!
    
    @IBOutlet var label_atpn_qesitm: UILabel!
    
    @IBOutlet var label_intrc_qesitm: UILabel!
    
    @IBOutlet var label_se_qesitm: UILabel!
    
    @IBOutlet var label_deposit_method_qesitm: UILabel!
    
    //view
    
    @IBOutlet var view_moreInfo: UIScrollView!
    
    @IBOutlet var view_moreInfo_vertical: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_main_ingredient: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_efcy_qesitem: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_use_method_qesitm: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_atpn_warn_qesitm: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_atpn_qesitm: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_intrc_qesitm: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_se_qesitm: UIStackView!
    
    @IBOutlet var view_moreInfo_horizontal_deposit_method_qesitm: UIStackView!
    
    
    var str_img_itemImg : String = ""
    var str_label_name : String = ""
    var str_label_shape : String = ""
    var str_label_color : String = ""
    var str_label_formulation : String = ""
    var str_label_dividingLine : String = ""
    var str_label_print : String = ""
    var str_label_etcOtcName : String = ""
    var str_label_enptName : String = ""
    var str_label_className : String = ""
    
    var conditional:String = ""
    
    let dbHelper = DBHelper.shared
    var dataArray: [MoreInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label_name.numberOfLines = 0
        
        getSegueData()
        start()
        
        if dataArray.count != 0 {
            setMoreInfo()
        }else{
            view_moreInfo.isHidden=true
        }//end of else if
        
//        print(" ")
//        print("Find frames that do not apply......")
//        getFrameSize()
        
    }//end of viewDidLoad

    func setLabelLineBreak() {
        let labels = [
            label_main_ingredient,
            label_efcy_qesitem,
            label_use_method_qesitm,
            label_atpn_warn_qesitm,
            label_atpn_qesitm,
            label_intrc_qesitm,
            label_se_qesitm,
            label_deposit_method_qesitm
        ]//end of labels
        
        
//        print("")
//        print("get CGSize label size & real size ----------------------")
        labels.forEach { label in
            setContent(label: label!)
            
            label!.frame.size.width = 304
            
            let labelHeight = setLabelHeightSize(label: label!).height
            label!.frame.size.height = labelHeight
            
            label!.lineBreakMode = .byCharWrapping
            label!.numberOfLines = 0
            
            label!.sizeToFit()
//            getLabelSize(label: label!)
            print("")
        }//end of forEach

        // Call setHorizontalRealSize for each horizontal stack view
        let horizontalViews = [
            view_moreInfo_horizontal_main_ingredient,
            view_moreInfo_horizontal_efcy_qesitem,
            view_moreInfo_horizontal_use_method_qesitm,
            view_moreInfo_horizontal_atpn_warn_qesitm,
            view_moreInfo_horizontal_atpn_qesitm,
            view_moreInfo_horizontal_intrc_qesitm,
            view_moreInfo_horizontal_se_qesitm,
            view_moreInfo_horizontal_deposit_method_qesitm
        ]//end of horizontalViews
        
//        print(" ")
//        print("Horizontal stack view = Label Size ----------------------")
        
        for (index, view) in horizontalViews.enumerated() {
            setHorizontalFrame(view: view!, label: labels[index]!)
        }//end of for
        
        horizontalViews.forEach{ view in
            view!.sizeToFit()
            view!.layoutIfNeeded()
        }//end of forEach
        
        setVerticalFrame()
        
//        getFrameSize()

//        print(" ")
//        print("vertical stack view real size: ", view_moreInfo_vertical.frame.height)
        
        view_moreInfo.layoutIfNeeded()
        view.layoutIfNeeded()
    }//end of setLabelLineBreak

    func setContent(label:UILabel){
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
    }//end of set content

    func setLabelHeightSize(label:UILabel) -> CGSize{
        let newSize = label.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
//        print("set CGSize : ",newSize)
        return newSize
    }//end of setLabelHeightSize
    
    func getLabelSize(label:UILabel){
        print("real width size : ",label.frame.size.width)
        print("real height size : ",label.frame.size.height)
    }//end of getLabelSize
    
    func setVerticalFrame(){
        let newFrameSize = view_moreInfo_vertical.sizeThatFits( CGSize(width: view_moreInfo_vertical.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        print(" ")
        print("vertical stack view set CGSize: ",newFrameSize)
        
        view_moreInfo_vertical.frame.size.height = newFrameSize.height
        view_moreInfo_vertical.sizeToFit()
    }//end of setFrameSize
    
    func getFrameSize(){
        let horizontal_view = [
            view_moreInfo_horizontal_main_ingredient,
            view_moreInfo_horizontal_efcy_qesitem,
            view_moreInfo_horizontal_use_method_qesitm,
            view_moreInfo_horizontal_atpn_warn_qesitm,
            view_moreInfo_horizontal_atpn_qesitm,
            view_moreInfo_horizontal_intrc_qesitm,
            view_moreInfo_horizontal_se_qesitm,
            view_moreInfo_horizontal_deposit_method_qesitm
        ]//end of labels
        
        print()
        print("Horizontal stack view real size ----------------------")
        
        horizontal_view.forEach { view in
            getHorizontalRealSize(view: view!)
        }//end of forEach
    
    }//end of getFrameSize
    
    func getHorizontalRealSize(view : UIStackView){
        print("Horizontal stack view real width : ",view.frame.size.width)
        print("Horizontal stack view real height : ",view.frame.size.height)
    }//end of getHorizontalRealSize
    
    func setHorizontalFrame(view: UIStackView, label: UILabel) {
        view.frame.size.height = label.frame.size.height
//        print("Horizontal stack view = Label Size : ", view.frame.size.height)
    }//end of setHorizontalFrame

    func getSegueData() {
        
        let url = URL(string: str_img_itemImg)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.img_itemImage.image = UIImage(data: data!)
            }//end of main
        }//end of global
        
        label_name.text = str_label_name
        label_shape.text = str_label_shape
        label_color.text = str_label_color
        label_formulation.text = str_label_formulation
        label_dividingLine.text = str_label_dividingLine
        label_print.text = str_label_print
        label_etcOtcName.text = str_label_etcOtcName
        label_entpName.text = str_label_enptName
        label_className.text = str_label_className
        
    }//end of getSegueData
    
    func start(){
        conditional = label_name.text!
        self.dataArray = dbHelper.readMoreInfoData(conditional: conditional)
        print(dataArray.count)
    }//end of start
    
    func setMoreInfo(){

        label_main_ingredient.text = String(dataArray[0].MAIN_INGREDIENT)
        label_efcy_qesitem.text = String(dataArray[0].EFCY_QESITEM)
        label_use_method_qesitm.text = String(dataArray[0].USE_METHOD_QESITM)
        label_atpn_warn_qesitm.text = String(dataArray[0].ATPN_WARN_QESITM)
        label_atpn_qesitm.text = String(dataArray[0].ATPN_QESITM)
        label_intrc_qesitm.text = String(dataArray[0].INTRC_QESITM)
        label_se_qesitm.text = String(dataArray[0].SE_QESITM)
        label_deposit_method_qesitm.text = String(dataArray[0].DEPOSIT_METHOD_QESITM)
        
        setLabelLineBreak()
        
    }//end of setMoreInfo
    

}//end of class
