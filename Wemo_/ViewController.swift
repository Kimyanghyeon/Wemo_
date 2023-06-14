//
//  ViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/07.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate,UITextFieldDelegate,MKMapViewDelegate{
    
    @IBOutlet var tf_input: UITextField!
    
    @IBOutlet var myMap: MKMapView!
    
    
    @IBOutlet var label_location_info: UILabel!
    
    @IBOutlet var sw_userLoc: UISwitch!
    
    @IBOutlet var btn_select_CameraORGallery: UIButton!
    
    
    //Prescription
    var str_service_name : String! = ""
    var str_business_status_code : String! = ""
    var str_business_status_name : String! = ""
    var str_company_phone_number : String! = ""
    var str_company_postal_address : String! = ""
    var str_company_all_address : String! = ""
    var str_company_road_name_address : String! = ""
    var str_company_road_name_postal_address : String! = ""
    var str_company_name : String! = ""
    var str_company_location_x : Double! = 0.0
    var str_company_location_y : Double! = 0.0
    
    //SelectItemName
    var str_item_name_select : String = ""
    var str_etc_otc_name_select : String = ""
    
    let locManager = CLLocationManager()
    
    var conditional:String = ""
    
    var mapLocation: CLLocation?
    
    //위치 정보
    let dbHelper = DBHelper.shared
    var dataArray: [Prescription] = []
    
    //약 정보
    var dataArray_medicines: [SelectItemName] = []
    
    // Create an array to store the added markers
    var addedMarkers: [MKPointAnnotation] = []
    
    var str_locality : String = ""
    var str_subLocality : String = ""
    
    //약 이름
    var str_medicines_name : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest //정확도
        locManager.requestWhenInUseAuthorization() //위치추적
        locManager.startUpdatingLocation() //위치 업데이트
        
        myMap.delegate = self
        //Cannot assign value of type 'ViewController' to type '(any MKMapViewDelegate)?'
        myMap.showsUserLocation = true // 위치값 공개
        
        tf_input.delegate = self
        
    }//end of viewDidLoad
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.clearsOnBeginEditing = true
        textField.resignFirstResponder() // Dismiss the keyboard
        searchLocation()
        return true
    }//end of textFieldShouldReturn
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }//end of touchesBegan
    
    @IBAction func sw_userLoc(_ sender: UISwitch) {
        if sender.isOn {
            self.label_location_info.text = ""
            locManager.stopUpdatingLocation()
            if let location = locManager.location {
                goLocation(lat: location.coordinate.latitude, log: location.coordinate.longitude, delta: 0.01)
                reverseGeocodeLocation(location)
            }//end of if let
        }else{
            let centerCoordinate = myMap.centerCoordinate
            let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
            reverseGeocodeLocation(location)
        }//end of else if
    }//end of sw_userLoc
    
    
    func goLocation(lat:CLLocationDegrees, log : CLLocationDegrees, delta span : Double){
        let pLocation = CLLocationCoordinate2DMake(lat, log)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let PRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(PRegion, animated: true)
        // Update str_locality and str_subLocality
        let coordinates = CLLocation(latitude: lat, longitude: log)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(coordinates) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.str_locality = placemark.locality ?? ""
                self.str_subLocality = placemark.subLocality ?? ""
            }//end of if
        }//end of geocoder
    }//end of goLocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let pLocation = locations.last {
            goLocation(lat: pLocation.coordinate.latitude, log: pLocation.coordinate.longitude, delta: 0.01)
        }//end of if let pLoc
        locManager.stopUpdatingLocation()
    }//end of locationManager
    
    func reverseGeocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placeMark = placemarks?.first else {
                self.label_location_info.text = "Address not found"
                return
            }//end of geocoder
            
            let addressComponents = [placeMark.country, placeMark.locality, placeMark.name]
            let address = addressComponents.compactMap { $0 }.joined(separator: " ")
            let addArr: [String] = address.components(separatedBy: " ")
            
            if addArr.count >= 5 {
                self.str_locality = addArr[1]
                self.str_subLocality = addArr[2]
            } else {
                self.str_locality = addArr.count >= 2 ? addArr[1] : " "
                self.str_subLocality = addArr.count >= 3 ? addArr[2] : " "
            }//end of if

            self.label_location_info.text = address
            
        }//end of let
    }//end of reverseGeocodeLocation
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.centerCoordinate
        let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        reverseGeocodeLocation(location)
    }//end of mapView
    
    func searchLocation() {
        if let searchQuery = tf_input.text, !searchQuery.isEmpty {
            if searchQuery == "약국" {
                conditional = "SERVICE_NAME = '약국' or COMPANY_ROAD_NAME_ADDRESS = '\(searchQuery)' or COMPANY_NAME = '\(searchQuery)'"
            } else {
                conditional = "SERVICE_NAME LIKE '%\(searchQuery)%' or COMPANY_ROAD_NAME_ADDRESS = '\(searchQuery)' or COMPANY_NAME = '\(searchQuery)'"
            }//end of else if
            
            self.dataArray = dbHelper.readPrescriptionData(conditional: conditional)
            print(dataArray.count)
        
            if dataArray.count != 0 {
                setPrescription()
                if dataArray.count > 1 {
                    searchLocalityQuery()
                    searchNearbyLocation()
                    
                } else if dataArray.count == 1, let address = dataArray.first?.COMPANY_ROAD_NAME_ADDRESS, let companyName = dataArray.first?.COMPANY_NAME {
                    geocodeCompanyAddress(address, companyName: companyName) { placemarks, error in
                        if let placemark = placemarks?.first {
                            let companyLocation = placemark.location
                            DispatchQueue.main.async {
                                self.goLocation(lat: companyLocation?.coordinate.latitude ?? 0.0, log: companyLocation?.coordinate.longitude ?? 0.0, delta: 0.01)
                                self.reverseGeocodeLocation(companyLocation ?? CLLocation())
                            }//end of DispatchQueue
                        }//end of if let
                    }//end of geocodeCompanyAddress
                }//end of companyName
            }else if dataArray.count == 0 {
                guard let popupVC = self.storyboard?.instantiateViewController(identifier: "PopUpViewController")as? PopUpViewController else {
                    return
                }//end of popupVC
                
                
                conditional = "ITEM_NAME = '\(searchQuery)'"
                self.dataArray_medicines = dbHelper.readSelectDataItemName(conditional: conditional)
                print(dataArray_medicines.count)
                setSelectItemName()
                
                popupVC.modalPresentationStyle = .overCurrentContext
                self.present(popupVC, animated: false, completion: nil)
                
                
            }else {
                label_location_info.text = "No results found"
            }//end of else if
        }//end of if searchQuery
    }//end of searchLocation
    
    func geocodeAddress(_ address: String?, companyName: String?) {
        guard let address = address, let companyName = companyName else {
            return
        }//end of let
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                let marker = MKPointAnnotation()
                marker.coordinate = placemark.location?.coordinate ?? CLLocationCoordinate2D()
                marker.title = companyName
                
                if let isMarkerAdded = self?.isMarkerAlreadyAdded(marker), !isMarkerAdded {
                    self?.myMap.addAnnotation(marker)
                    self?.addedMarkers.append(marker)
                    
                }//end of if
            }//end of if let
        }//end of geocoder
    }//end of geocodeAddress
    
    func isMarkerAlreadyAdded(_ marker: MKPointAnnotation) -> Bool {
        return addedMarkers.contains { addedMarker in
            return addedMarker.coordinate.latitude == marker.coordinate.latitude &&
            addedMarker.coordinate.longitude == marker.coordinate.longitude &&
            addedMarker.title == marker.title
        }//end of addedMarkers
    }//end of isMarkerAlreadyAdded
    
    func setPrescription(){
        for i in 0..<dataArray.count{
            str_service_name = String(dataArray[i].SERVICE_NAME)
            str_business_status_code = String(dataArray[i].BUSINESS_STATUS_CODE)
            str_business_status_name = String(dataArray[i].BUSINESS_STATUS_NAME)
            str_company_phone_number = String(dataArray[i].COMPANY_PHONE_NUMBER)
            str_company_postal_address = String(dataArray[i].COMPANY_POSTAL_ADDRESS)
            str_company_all_address = String(dataArray[i].COMPANY_ALL_ADDRESS)
            str_company_road_name_address = String(dataArray[i].COMPANY_ROAD_NAME_ADDRESS)
            str_company_road_name_postal_address = String(dataArray[i].COMPANY_ROAD_NAME_POSTAL_ADDRESS)
            str_company_name = String(dataArray[i].COMPANY_NAME)
            str_company_location_x = dataArray[i].COMPANY_LOCATION_X
            str_company_location_y = dataArray[i].COMPANY_LOCATION_Y
            
            dataArray.append(Prescription(SERVICE_NAME: str_service_name, BUSINESS_STATUS_CODE: str_business_status_code, BUSINESS_STATUS_NAME: str_business_status_name, COMPANY_PHONE_NUMBER: str_company_phone_number, COMPANY_POSTAL_ADDRESS: str_company_postal_address, COMPANY_ALL_ADDRESS: str_company_all_address, COMPANY_ROAD_NAME_ADDRESS: str_company_road_name_address, COMPANY_ROAD_NAME_POSTAL_ADDRESS: str_company_road_name_postal_address, COMPANY_NAME: str_company_name, COMPANY_LOCATION_X: str_company_location_x, COMPANY_LOCATION_Y: str_company_location_y))
        }//end of for
        
        //print(dataArray)
        
    }//end of setPrescription
    
    func setSelectItemName(){
        for i in 0..<dataArray_medicines.count{
            str_item_name_select = dataArray_medicines[i].ITEM_NAME_SElECT
            str_etc_otc_name_select = dataArray_medicines[i].ETC_OTC_NAME_SElECT
            dataArray_medicines.append(SelectItemName(ITEM_NAME_SElECT: str_item_name_select, ETC_OTC_NAME_SElECT: str_etc_otc_name_select))
            checkSelectItemName(etc_otc_name : str_etc_otc_name_select)
        }//end of for

    }//end of setSelectItemName
    
    func checkSelectItemName(etc_otc_name : String){
        if etc_otc_name == "일반(안전상비)"{
            conditional = "SERVICE_NAME = '안전상비의약품 판매업소'and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_locality)%' and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_subLocality)%'"
            self.dataArray = dbHelper.readPrescriptionData(conditional: conditional)
            print(dataArray.count)
            setPrescription()
            searchNearbyLocation()
        }else if etc_otc_name == "일반의약품"{
            conditional = "SERVICE_NAME = '약국'and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_locality)%' and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_subLocality)%'"
            self.dataArray = dbHelper.readPrescriptionData(conditional: conditional)
            print(dataArray.count)
            setPrescription()
            searchNearbyLocation()
        }//end of else if
    }//end of checkSelectItemName
    
    func searchLocalityQuery(){
        print("userLocation : \(String(describing: label_location_info.text))")

        if let searchQuery = tf_input.text, !searchQuery.isEmpty {
            if searchQuery == "약국" {
                conditional = "SERVICE_NAME = '약국' and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_locality)%' and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_subLocality)%' or COMPANY_NAME = '\(searchQuery)'"
            } else {
                conditional = "SERVICE_NAME LIKE '%\(searchQuery)%' and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_locality)%' and COMPANY_ROAD_NAME_ADDRESS LIKE '%\(str_subLocality)%' or COMPANY_NAME = '\(searchQuery)'"
            }//end of else if
            self.dataArray = dbHelper.readPrescriptionData(conditional: conditional)
            print(dataArray.count)
        }//end of searchQuery
    }//end of searchLocalityQuery

    func searchNearbyLocation() {
        let userLocation = CLLocation(latitude: locManager.location?.coordinate.latitude ?? 0.0, longitude: locManager.location?.coordinate.longitude ?? 0.0)
        
        print("userLocation : \(String(describing: label_location_info.text))")
        
        myMap.removeAnnotations(myMap.annotations)
        
        for data in dataArray{
            let marker = MKPointAnnotation()
            let companyName = data.COMPANY_NAME
            let companyAddress = data.COMPANY_ROAD_NAME_ADDRESS
            
            geocodeCompanyAddress(companyAddress, companyName: companyName) { placemarks, error in
                if let placemark = placemarks?.first {
                    let companyLocation = placemark.location
                    marker.coordinate = companyLocation?.coordinate ?? CLLocationCoordinate2D()
                    marker.title = companyName
                    marker.subtitle = companyAddress
                    
                    if self.sw_userLoc.isOn {
                        DispatchQueue.main.async {
                            self.myMap.addAnnotation(marker)
                            self.myMap.setCenter(userLocation.coordinate, animated: true)
                        } //end of DispatchQueue closure
                    }else{
                        DispatchQueue.main.async {
                            let centerCoordinate = self.myMap.centerCoordinate
                            let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
                            self.myMap.addAnnotation(marker)
                            self.myMap.setCenter(location.coordinate, animated: true)
                        } //end of DispatchQueue closure
                    }//end of else if
                    
                } //end of if let statement
            } //end of geocodeCompanyAddress closure
            
        } //end of for
        
        print("Search completed")
    } //end of searchNearbyLocation function

    
    func geocodeCompanyAddress(_ address: String?, companyName: String?, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        guard let address = address else {
            return
        }//end of let
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            completion(placemarks, error)
        }//end of let
    }//end of geocodeCompanyAddress
    

    
    
    
}//end of class



