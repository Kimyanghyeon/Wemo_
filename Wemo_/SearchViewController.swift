//
//  SearchViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/07.
//

import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //select name
    
    @IBOutlet var tf_select_name: UITextField!
    
    //select color
    
    @IBOutlet var img_shape_circle: UIImageView!
    
    @IBOutlet var img_shape_oval: UIImageView!
    
    @IBOutlet var img_shape_semicircle: UIImageView!
    
    @IBOutlet var img_shape_triangle: UIImageView!
    
    @IBOutlet var img_shape_rectangle: UIImageView!
    
    @IBOutlet var img_shape_polygon: UIImageView!
    
    @IBOutlet var img_shape_rhombus: UIImageView!
    
    @IBOutlet var img_shape_square: UIImageView!
    
    @IBOutlet var img_shape_etc: UIImageView!
    
    @IBOutlet var btn_select_shape: UIButton!
    
    //selectColor
    
    @IBOutlet var img_color_white: UIImageView!
    
    @IBOutlet var img_color_red: UIImageView!
    
    @IBOutlet var img_color_orange: UIImageView!
    
    @IBOutlet var img_color_yellow: UIImageView!
    
    @IBOutlet var img_color_lightgreen: UIImageView!
    
    @IBOutlet var img_color_green: UIImageView!
    
    @IBOutlet var img_color_turauoise: UIImageView!
    
    @IBOutlet var img_color_blue: UIImageView!
    
    @IBOutlet var img_color_Indigo: UIImageView!
    
    @IBOutlet var img_color_purple: UIImageView!
    
    @IBOutlet var img_color_pinkpurple: UIImageView!
    
    @IBOutlet var img_color_pink: UIImageView!
    
    @IBOutlet var img_color_brown: UIImageView!
    
    @IBOutlet var img_color_gray: UIImageView!
    
    @IBOutlet var img_color_black: UIImageView!
    
    @IBOutlet var img_color_null: UIImageView!
    
    @IBOutlet var btn_select_color: UIButton!
    
    //selectFormulation
    
    @IBOutlet var img_formulation_tablet: UIImageView!
    
    @IBOutlet var img_formulation_hard: UIImageView!
    
    @IBOutlet var img_formulation_etc: UIImageView!
    
    @IBOutlet var btn_select_formulation: UIButton!
    
    //selectDividingLine
    
    @IBOutlet var img_dividingLine_none: UIImageView!
    
    @IBOutlet var img_dividingLine_minus: UIImageView!
    
    @IBOutlet var img_dividingLine_plus: UIImageView!
    
    @IBOutlet var img_dividingLine_etc: UIImageView!
    
    @IBOutlet var btn_select_dividingLine: UIButton!
    
    //select mark
    
    @IBOutlet var tf_select_print: UITextField!
    
    @IBOutlet var btn_select_print: UIButton!
    
    @IBOutlet var btn_input_print: UIButton!
   
    
    //select etcOtcName
    
    @IBOutlet var btn_etcOtcName_prescription: UIButton!
    
    @IBOutlet var btn_etcOtcName_overTheCounter: UIButton!
    
    @IBOutlet var btn_etcOtcName_orphan: UIButton!
    
    @IBOutlet var btn_etcOtcName_safety: UIButton!
    
    @IBOutlet var btn_select_etcOtcName: UIButton!
    
    //select enptName
    
    @IBOutlet var tf_select_enptName: UITextField!
    
    @IBOutlet var btn_select_enptName: UIButton!
    
    @IBOutlet var btn_input_enptName: UIButton!
    
    // OCR
    @IBOutlet var btn_select_cameraOrGallery: UIButton!
    
    let imagePickerController = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf_select_name.delegate=self
        tf_select_print.delegate=self
        tf_select_enptName.delegate=self
        
        imagePickerController.sourceType = .camera
        
        selectImg()
        setBtnTitle()
        setPullDownBtn()
        
    }//end of viewDidLoad
    
    
    
    func setBtnTitle(){
        
        tf_select_enptName.addTarget(self, action: #selector(textFieldDidChanacgeEnptName(_:)), for: .editingDidEnd)
        tf_select_print.addTarget(self, action: #selector(textFieldDidChanacgePrint(_:)), for: .editingDidEnd)
        
        btn_select_shape.layer.borderWidth=0.5
        btn_select_shape.layer.cornerRadius=10
        
        
        btn_select_color.layer.borderWidth=0.5
        btn_select_color.layer.cornerRadius=10
        
        btn_select_formulation.layer.borderWidth=0.5
        btn_select_formulation.layer.cornerRadius=10
        
        btn_select_dividingLine.layer.borderWidth=0.5
        btn_select_dividingLine.layer.cornerRadius=10
        
        btn_select_print.layer.borderWidth=0.5
        btn_select_print.layer.cornerRadius=10
        
        btn_select_etcOtcName.layer.borderWidth=0.5
        btn_select_etcOtcName.layer.cornerRadius=10
        
        btn_select_enptName.layer.borderWidth=0.5
        btn_select_enptName.layer.cornerRadius=10
        
    }//end setBtnTitle
    
    func selectImg(){
        //select color
        img_shape_circle.isUserInteractionEnabled=true
        img_shape_oval.isUserInteractionEnabled=true
        img_shape_semicircle.isUserInteractionEnabled=true
        img_shape_triangle.isUserInteractionEnabled=true
        img_shape_rectangle.isUserInteractionEnabled=true
        img_shape_polygon.isUserInteractionEnabled=true
        img_shape_rhombus.isUserInteractionEnabled=true
        img_shape_square.isUserInteractionEnabled=true
        img_shape_etc.isUserInteractionEnabled=true
        
        let eventCircle = UITapGestureRecognizer(target: self, action: #selector(shapeCircle))
        let eventOval = UITapGestureRecognizer(target: self, action: #selector(shapeOval))
        let eventSemicircle = UITapGestureRecognizer(target: self, action: #selector(shapeSemicircle))
        let eventTriangle = UITapGestureRecognizer(target: self, action: #selector(shapeTriangle))
        
        let eventRectangle = UITapGestureRecognizer(target: self, action: #selector(shapeRectangle))
        let eventPolygon = UITapGestureRecognizer(target: self, action: #selector(shapePolygon))
        let eventRhombus = UITapGestureRecognizer(target: self, action: #selector(shapeRhombus))
        let eventSquare = UITapGestureRecognizer(target: self, action: #selector(shapeSquare))
        let eventEtc = UITapGestureRecognizer(target: self, action: #selector(shapeEtc))
        
        img_shape_circle.addGestureRecognizer(eventCircle)
        img_shape_oval.addGestureRecognizer(eventOval)
        img_shape_semicircle.addGestureRecognizer(eventSemicircle)
        img_shape_triangle.addGestureRecognizer(eventTriangle)
        img_shape_rectangle.addGestureRecognizer(eventRectangle)
        img_shape_polygon.addGestureRecognizer(eventPolygon)
        img_shape_rhombus.addGestureRecognizer(eventRhombus)
        img_shape_square.addGestureRecognizer(eventSquare)
        img_shape_etc.addGestureRecognizer(eventEtc)

        //selectColor
        img_color_white.isUserInteractionEnabled=true
        img_color_red.isUserInteractionEnabled=true
        img_color_orange.isUserInteractionEnabled=true
        img_color_yellow.isUserInteractionEnabled=true
        img_color_lightgreen.isUserInteractionEnabled=true
        img_color_green.isUserInteractionEnabled=true
        img_color_turauoise.isUserInteractionEnabled=true
        img_color_blue.isUserInteractionEnabled=true
        img_color_Indigo.isUserInteractionEnabled=true
        img_color_purple.isUserInteractionEnabled=true
        img_color_pinkpurple.isUserInteractionEnabled=true
        img_color_pink.isUserInteractionEnabled=true
        img_color_brown.isUserInteractionEnabled=true
        img_color_gray.isUserInteractionEnabled=true
        img_color_black.isUserInteractionEnabled=true
        img_color_null.isUserInteractionEnabled=true
        
        let eventWhite = UITapGestureRecognizer(target: self, action: #selector(colorWhite))
        let eventRed = UITapGestureRecognizer(target: self, action: #selector(colorRed))
        let eventOrange = UITapGestureRecognizer(target: self, action: #selector(colorOrange))
        let eventYellow = UITapGestureRecognizer(target: self, action: #selector(colorYellow))
        let eventLightgreen = UITapGestureRecognizer(target: self, action: #selector(colorLightgreen))
        let eventGreen = UITapGestureRecognizer(target: self, action: #selector(colorGreen))
        let eventTurauoise = UITapGestureRecognizer(target: self, action: #selector(colorTurauoise))
        let eventBlue = UITapGestureRecognizer(target: self, action: #selector(colorBlue))
        let eventIndigo = UITapGestureRecognizer(target: self, action: #selector(colorIndigo))
        let eventPurple = UITapGestureRecognizer(target: self, action: #selector(colorPurple))
        let eventPinkpurple = UITapGestureRecognizer(target: self, action: #selector(colorPinkpurple))
        let eventPink = UITapGestureRecognizer(target: self, action: #selector(colorPink))
        let eventBrown = UITapGestureRecognizer(target: self, action: #selector(colorBrowm))
        let eventGray = UITapGestureRecognizer(target: self, action: #selector(colorGray))
        let eventBlack = UITapGestureRecognizer(target: self, action: #selector(colorBlack))
        let eventNull = UITapGestureRecognizer(target: self, action: #selector(colorNull))
        
        img_color_white.addGestureRecognizer(eventWhite)
        img_color_red.addGestureRecognizer(eventRed)
        img_color_orange.addGestureRecognizer(eventOrange)
        img_color_yellow.addGestureRecognizer(eventYellow)
        img_color_lightgreen.addGestureRecognizer(eventLightgreen)
        img_color_green.addGestureRecognizer(eventGreen)
        img_color_turauoise.addGestureRecognizer(eventTurauoise)
        
        img_color_blue.addGestureRecognizer(eventBlue)
        img_color_Indigo.addGestureRecognizer(eventIndigo)
        img_color_purple.addGestureRecognizer(eventPurple)
        img_color_pinkpurple.addGestureRecognizer(eventPinkpurple)
        img_color_pink.addGestureRecognizer(eventPink)
        img_color_brown.addGestureRecognizer(eventBrown)
        img_color_gray.addGestureRecognizer(eventGray)
        img_color_black.addGestureRecognizer(eventBlack)
        img_color_null.addGestureRecognizer(eventNull)
        
        //selectFormulation
        
        img_formulation_tablet.isUserInteractionEnabled=true
        img_formulation_hard.isUserInteractionEnabled=true
        img_formulation_etc.isUserInteractionEnabled=true
        
        let eventTablet  = UITapGestureRecognizer(target: self, action: #selector(formulationTablet))
        let eventHard  = UITapGestureRecognizer(target: self, action: #selector(formulationHard))
        let eventEtc_f  = UITapGestureRecognizer(target: self, action: #selector(formulationEtc))
        
        img_formulation_tablet.addGestureRecognizer(eventTablet)
        img_formulation_hard.addGestureRecognizer(eventHard)
        img_formulation_etc.addGestureRecognizer(eventEtc_f)
        
        //selectDividingLine
        
        img_dividingLine_none.isUserInteractionEnabled=true
        img_dividingLine_minus.isUserInteractionEnabled=true
        img_dividingLine_plus.isUserInteractionEnabled=true
        img_dividingLine_etc.isUserInteractionEnabled=true
        
        let eventNone = UITapGestureRecognizer(target: self, action: #selector(dividingLineNone))
        let eventMinus = UITapGestureRecognizer(target: self, action: #selector(dividingLineMinus))
        let eventPlus = UITapGestureRecognizer(target: self, action: #selector(dividingLinePlus))
        let eventEtc_dl = UITapGestureRecognizer(target: self, action: #selector(dividingLineEtc))
        
        img_dividingLine_none.addGestureRecognizer(eventNone)
        img_dividingLine_minus.addGestureRecognizer(eventMinus)
        img_dividingLine_plus.addGestureRecognizer(eventPlus)
        img_dividingLine_etc.addGestureRecognizer(eventEtc_dl)
    }//end of selectImg
    
    //SearchView
    func resetSelect(){
        btn_select_shape.setTitle("모양", for: .normal)
        btn_select_color.setTitle("색상", for: .normal)
        btn_select_formulation.setTitle("제형", for: .normal)
        btn_select_dividingLine.setTitle("분할선", for: .normal)
        btn_select_print.setTitle("마크", for: .normal)
        btn_select_enptName.setTitle("업체", for: .normal)
        btn_select_etcOtcName.setTitle("구분", for: .normal)
        tf_select_name.text=""
        tf_select_print.text=""
        tf_select_enptName.text=""
    }//end of resetSelect
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }//end of touchesBegan
    
    //return keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> (Bool) {
        
        tf_select_name.endEditing(true)
        tf_select_print.endEditing(true)
        tf_select_enptName.endEditing(true)
        
        tf_select_name.clearsOnBeginEditing = true
        tf_select_print.clearsOnBeginEditing = true
        tf_select_enptName.clearsOnBeginEditing = true
        
        btn_select_print.setTitle(tf_select_print.text, for: .normal)
        btn_select_enptName.setTitle(tf_select_enptName.text, for: .normal)
        
        print(tf_select_name.text!)
        print(tf_select_print.text!)
        print(tf_select_enptName.text!)
        
        return true
    }//end of textFieldShouldReturn
    
    func setPullDownBtn(){
        
        let camera = UIAction(title: "카메라로 촬영하기", image: UIImage(systemName: "camera.fill")) { _ in
            self.selectFromCamera()
        }//end of camera
        
        let gallery = UIAction(title: "갤러리에서 선택하기", image: UIImage(systemName: "photo.fill.on.rectangle.fill")) { _ in
            self.selectFromGallery()
        }//end of gallery
        
        self.btn_select_cameraOrGallery.menu = UIMenu(title: "사진 선택",
                                     identifier: nil,
                                     options: .displayInline,
                                     children: [camera, gallery])
        
        self.btn_select_cameraOrGallery.showsMenuAsPrimaryAction = true
        
//        자식 메뉴 선택시 자식 메뉴의 타이틀로 부모 버튼 타이틀 변경
//        self.btn_select_cameraOrGallery.changesSelectionAsPrimaryAction = true
        

    }//end of setPullDownBtn

    
    //------------------------------------------------------------------------------------------------------
    
    @objc func shapeCircle() -> (){
        btn_select_shape.setTitle("원형", for: .normal);
    }//end of shapeCircle
    
    @objc func shapeOval() -> (){
        btn_select_shape.setTitle("타원형", for: .normal);
    }//end of shapeOval
    
    @objc func shapeSemicircle() -> (){
        btn_select_shape.setTitle("반원형", for: .normal);
    }//end of shapeSemicircle
    
    @objc func shapeTriangle() -> (){
        btn_select_shape.setTitle("삼각형", for: .normal);
    }//end of shapeTriangle
    
    @objc func shapeRectangle()->(){
        btn_select_shape.setTitle("사각형", for: .normal);
    }//end of shapeRectangle
    
    @objc func shapePolygon()->(){
        btn_select_shape.setTitle("다각형", for: .normal);
    }//end of shapeRectangle
    
    @objc func shapeRhombus() -> (){
        btn_select_shape.setTitle("마름모형", for: .normal);
    }//end of shapeRhombus
    
    @objc func shapeSquare()->(){
        btn_select_shape.setTitle("장방형", for: .normal);
    }//end of shapeRquare
    
    @objc func shapeEtc()->(){
        btn_select_shape.setTitle("기타", for: .normal);
    }//end of shapeRtc

    
    @IBAction func selectShape(_ sender: UIButton) {
        btn_select_shape.setTitle("모양", for: .normal);
    }//end of selectShape
        
    
    //------------------------------------------------------------------------------------------------------
    //selectColor
    
    @objc func colorWhite() -> (){
        btn_select_color.setTitle("하양", for: .normal)
    }//end of colorWhite
    
    @objc func colorRed() -> (){
        btn_select_color.setTitle("빨강", for: .normal)
    }//end of colorRed
    
    @objc func colorOrange() -> (){
        btn_select_color.setTitle("주황", for: .normal)
    }//end of colorOrange
    
    @objc func colorYellow() -> (){
        btn_select_color.setTitle("노랑", for: .normal)
    }//end of colorYellow
    
    @objc func colorLightgreen() -> (){
        btn_select_color.setTitle("연두", for: .normal)
    }//end of colorLightgreen
    
    @objc func colorGreen() -> (){
        btn_select_color.setTitle("초록", for: .normal)
    }//end of colorGreen
    
    @objc func colorTurauoise() -> (){
        btn_select_color.setTitle("청록", for: .normal)
    }//end of colorTurauoise
    
    @objc func colorBlue() -> (){
        btn_select_color.setTitle("파랑", for: .normal)
    }//end of colorBlue
    
    @objc func colorIndigo() -> (){
        btn_select_color.setTitle("남색", for: .normal)
    }//end of colorIndigo
    
    @objc func colorPurple() -> (){
        btn_select_color.setTitle("보라", for: .normal)
    }//end of colorPurple
    
    @objc func colorPinkpurple() -> (){
        btn_select_color.setTitle("자주", for: .normal)
    }//end of colorPinkpurple
    
    @objc func colorPink() -> (){
        btn_select_color.setTitle("분홍", for: .normal)
    }//end of colorPinkpurple
    
    @objc func colorBrowm() -> (){
        btn_select_color.setTitle("갈색", for: .normal)
    }//end of colorPinkpurple
    
    @objc func colorGray() -> (){
        btn_select_color.setTitle("회색", for: .normal)
    }//end of colorGray
    
    @objc func colorBlack() -> (){
        btn_select_color.setTitle("검정", for: .normal)
    }//end of colorBlack
    
    @objc func colorNull() -> (){
        btn_select_color.setTitle("투명", for: .normal)
    }//end of colorNull
        
    @IBAction func selectColor(_ sender: UIButton) {
        btn_select_color.setTitle("색상", for: .normal)
    }//end of selectColor
    
    //------------------------------------------------------------------------------------------------------
    //selectFormulation
    
    @objc func formulationTablet() -> (){
        btn_select_formulation.setTitle("정제형", for: .normal)
    }//end of formulationTablet
    
    @objc func formulationHard() -> (){
        btn_select_formulation.setTitle("캡슐형", for: .normal)
    }//end of formulationTablet
    
    @objc func formulationEtc() -> (){
        btn_select_formulation.setTitle("기타", for: .normal)
    }//end of formulationEtc
    

    @IBAction func selectFormulation(_ sender: UIButton) {
        btn_select_formulation.setTitle("제형", for: .normal)
    }//end of selectFormulation
    
    //------------------------------------------------------------------------------------------------------
    //selectDividingLine
    
    @objc func dividingLineNone() -> (){
        btn_select_dividingLine.setTitle("없음", for: .normal)
    }//end of dividingLineNone
    
    @objc func dividingLineMinus() -> (){
        btn_select_dividingLine.setTitle("(-)형", for: .normal)
    }//end of dividingLineMinus
    
    @objc func dividingLinePlus() -> (){
        btn_select_dividingLine.setTitle("(+)형", for: .normal)
    }//end of dividingLinePlus
    
    @objc func dividingLineEtc() -> (){
        btn_select_dividingLine.setTitle("기타", for: .normal)
    }//end of dividingLineEtc
    
    @IBAction func selectDividingLine(_ sender: UIButton) {
        btn_select_dividingLine.setTitle("분할선", for: .normal)
    }//end of selectDividingLine
    
    //select print
    
    @objc func textFieldDidChanacgePrint(_ sender: Any?) {
        if tf_select_print.text=="" {
            btn_select_print.setTitle("마크", for: .normal)
        }else{
            btn_select_print.setTitle(tf_select_print.text, for: .normal)
        }//end of else if
    }//end of textFieldDidChanacgePrint
    
    @IBAction func selectPrint(_ sender: UIButton) {
        btn_select_print.setTitle("마크", for: .normal)
    }//end of selectPrint
    
    //------------------------------------------------------------------------------------------------------
    //select etcOtcName
    
    @IBAction func selectEtcOtcNamePrescription(_ sender: UIButton) {
        btn_select_etcOtcName.setTitle("전문의약품", for: .normal)
    }//end of selectEtcOtcNamePrescription
    
    @IBAction func selectEtcOtcNameOverTheCounter(_ sender: UIButton) {
        btn_select_etcOtcName.setTitle("일반의약품", for: .normal)
    }//end of selectEtcOtcNameOverTheCounter
    
    @IBAction func selectEtcOtcNameOrphan(_ sender: UIButton) {
        btn_select_etcOtcName.setTitle("전문 | 희귀", for: .normal)
    }//end of selectEtcOtcNameOrphan
    
    @IBAction func selectEtcOtcNameSafety(_ sender: UIButton) {
        btn_select_etcOtcName.setTitle("일반(안전상비)", for: .normal)
    }//end of selectEtcOtcNameSafety
    
    @IBAction func selectEtcOtcName(_ sender: Any) {
        btn_select_etcOtcName.setTitle("구분", for: .normal)
    }//end of selectEtcOtcName
    
//------------------------------------------------------------------------------------------------------
  //select enptName
   
    @objc func textFieldDidChanacgeEnptName(_ sender: Any?) {
        if tf_select_enptName.text==""{
            btn_select_enptName.setTitle("업체", for: .normal)
        }else{
            btn_select_enptName.setTitle(tf_select_enptName.text, for: .normal)
        }//end of else if
    }//end of textFieldDidChanacgeEnptName
    
    
    @IBAction func selectEnptName(_ sender: UIButton) {
        btn_select_enptName.setTitle("업체", for: .normal)
    }//end of selectEnptName
    
    
    //------------------------------------------------------------------------------------------------------
    
    @IBAction func searchSelctAttribute(_ sender: UIButton) {
        guard let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {return}
      
        listVC.str_label_name = tf_select_name.text ?? ""
        listVC.str_label_shape = btn_select_shape.titleLabel?.text ?? ""
        listVC.str_label_color = btn_select_color.titleLabel?.text ?? ""
        listVC.str_label_formulation = btn_select_formulation.titleLabel?.text ?? ""
        listVC.str_label_dividingLine = btn_select_dividingLine.titleLabel?.text ?? ""
        listVC.str_label_print = btn_select_print.titleLabel?.text ?? ""
        listVC.str_label_etcOtcName = btn_select_etcOtcName.titleLabel?.text ?? ""
        listVC.str_label_enptName = btn_select_enptName.titleLabel?.text ?? ""

        self.navigationController?.pushViewController(listVC, animated: true)
    }//end of search
    
    
    @IBAction func searchInputAttribute(_ sender: Any) {
        guard let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {return}
        
        listVC.str_label_name = tf_select_name.text ?? ""
        
        self.navigationController?.pushViewController(listVC, animated: true)
    }//end of searchInputAttribute
    
    //------------------------------------------------------------------------------------------------------
    func selectFromCamera() {
        print("카메라로 촬영하기를 선택하셨습니다")
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        present(self.imagePickerController, animated: true, completion: nil)
    }//end of selectFromCamera
    
    func selectFromGallery() {
        print("갤러리에서 선택하기를 선택하셨습니다")
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
    }//end of selectFromGallery
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                if let imageSubVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageSubViewController") as? ImageSubViewController {
                    imageSubVC.sendSelectImg = image
                    imageSubVC.modalPresentationStyle = .automatic
                    self.present(imageSubVC, animated: true, completion: nil)
                } else {
                    fatalError("Failed to instantiate ImageSubViewController from storyboard.")
                }//end of if let
            }//end of picker
        }else{
            fatalError("선택된 이미지를 불러오지 못했습니다 ")
        }//end of else if let
    }//end of imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }//end of imagePickerControllerDidCancel
    

}//end of class
