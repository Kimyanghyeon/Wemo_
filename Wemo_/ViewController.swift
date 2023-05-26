//
//  ViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/07.
//

import UIKit
import CoreLocation

struct getPrescription : Codable{
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
}//end of getPrescription

struct Location {
    let latitude: Double
    let longitude: Double
}//end of Location

class ViewController: UIViewController , MTMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet var view_mapContent: UIView!
    
    
    @IBOutlet var zoomIn: UIButton!
    @IBOutlet var zoomOut: UIButton!
    
    var mapView: MTMapView?
        
    
    var userLatitude : Double = 0.0
    var userLongitude : Double = 0.0
    
    var allCircle = [MTMapCircle]()
    
    //사용자 위치
    var locationManger = CLLocationManager()
    
    //zoomLevel
    var zoomLevel : Int = 2
    
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
    
    var conditional:String = ""
    
    var company_name : Array<String> = []
    
    let dbHelper = DBHelper.shared
    var dataArray: [Prescription] = []
    
    let TO_GPS_FROM_GRID = 2
    let TO_GRID = 1
    let TO_GPS = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMapView()
        getUserLocation()
        start()

   }//end of viewDidLoad
    
    func setMapView() {
        mapView = MTMapView(frame: view_mapContent.frame)
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            

            locationManger.delegate = self
            locationManger.requestWhenInUseAuthorization()
            locationManger.startUpdatingLocation()
    
            view_mapContent.addSubview(mapView)
            view_mapContent.addSubview(zoomIn)
            view_mapContent.addSubview(zoomOut)
            
            //강제 제약조건
            mapView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mapView.leadingAnchor.constraint(equalTo: view_mapContent.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view_mapContent.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view_mapContent.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view_mapContent.bottomAnchor)
            ])//end of NSLayoutConstraint
            
//            print(view_mapContent.subviews)
//            print(view_mapContent.isHidden)
            
            print("setMapView executed")
        } else {
            print("Failed to create mapView")
        }//end of else if
        
    }//end of setMapView
    
    func getUserLocation() {
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        
        if locationManger.authorizationStatus == .authorizedWhenInUse || locationManger.authorizationStatus == .authorizedAlways {
            locationManger.startUpdatingLocation()
        } else {
            print("Location services authorization not granted.")
        }//end of else if
    }//end of getUserLocation
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정 완료")
        case .restricted, .notDetermined:
            print("GPS 권한 설정 실패")
        case .denied:
            print("GPS 권한 설정 거부")
        default:
            print("GPS: Default")
        }//end of switch
    }//end of locationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Latitude: \(latitude)")
        print("Longitude: \(longitude)")
        
        userLatitude = latitude
        userLongitude = longitude
        

        let LocationNow = CLLocation(latitude: userLatitude, longitude: userLongitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko-kr")
        geocoder.reverseGeocodeLocation(LocationNow, preferredLocale: locale, completionHandler: {(placemarks, error)in
            if let address:[CLPlacemark]=placemarks{
                if let country:String = address.last?.country{print(country)}
                if let administrativeArea : String=address.last?.administrativeArea{print(administrativeArea)}
                if let locality : String = address.last?.locality{print(locality)}
                if let name:String = address.last?.name{print(name)}
            }//end of if let
        })//end of reverseGeocodeLocation
        
        if let mapView = mapView {
            let poiItem = setUserLocationPoint(itemName: "내 위치", getla: userLatitude, getlo: userLongitude, markerType: MTMapPOIItemMarkerType.redPin)
            
            mapView.setMapCenter(poiItem.mapPoint, animated: true)
            mapView.setZoomLevel(MTMapZoomLevel(zoomLevel), animated: true)
            mapView.addPOIItems([poiItem])
           // mapView.fitAreaToShowAllPOIItems()
            
            print("Map view is available")
        } else {
            print("Map view is not available")
        }//end of let else if
            
        locationManger.stopUpdatingLocation()
        
        print("locationManager didUpdateLocations executed")
        
        printDataArray()
        
    }//end of locationManager
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }//end of locationManager
    
    func setUserLocationPoint(itemName: String, getla: Double, getlo: Double, markerType: MTMapPOIItemMarkerType) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = itemName
        poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: getla, longitude: getlo))
        poiItem.markerType = markerType
        
        print("setUserLocationPoint executed")
        
        return poiItem
    }//end of setUserLocationPoint
    
    
    @IBAction func zoomIn(_ sender: UIButton) {
        zoomLevel-=1
        mapView?.setZoomLevel(MTMapZoomLevel(zoomLevel), animated: true)
    }//end of zoomIn
    
    
    @IBAction func zoomOut(_ sender: UIButton) {
        zoomLevel+=1
        mapView?.setZoomLevel(MTMapZoomLevel(zoomLevel), animated: true)
    }//end of zoomOut
    
    func start(){
        self.dataArray = dbHelper.readPrescriptionDataAll()
        print(dataArray.count)

    }//end of start
    
    func setPrescriptionDataAll(){
        
        str_service_name = String(dataArray[0].SERVICE_NAME)
        str_business_status_code = String(dataArray[1].BUSINESS_STATUS_CODE)
        str_business_status_name = String(dataArray[2].BUSINESS_STATUS_NAME)
        str_company_phone_number = String(dataArray[3].COMPANY_PHONE_NUMBER)
        str_company_postal_address = String(dataArray[4].COMPANY_POSTAL_ADDRESS)
        str_company_all_address = String(dataArray[5].COMPANY_ALL_ADDRESS)
        str_company_road_name_address = String(dataArray[6].COMPANY_ROAD_NAME_ADDRESS)
        str_company_road_name_postal_address = String(dataArray[7].COMPANY_ROAD_NAME_POSTAL_ADDRESS)
        str_company_name = String(dataArray[8].COMPANY_NAME)
        str_company_location_x = dataArray[9].COMPANY_LOCATION_X
        str_company_location_y = dataArray[10].COMPANY_LOCATION_Y
        
        dataArray.append(Prescription(SERVICE_NAME: str_service_name, BUSINESS_STATUS_CODE: str_business_status_code, BUSINESS_STATUS_NAME: str_business_status_name, COMPANY_PHONE_NUMBER: str_company_phone_number, COMPANY_POSTAL_ADDRESS: str_company_postal_address, COMPANY_ALL_ADDRESS: str_company_all_address, COMPANY_ROAD_NAME_ADDRESS: str_company_road_name_address, COMPANY_ROAD_NAME_POSTAL_ADDRESS: str_company_road_name_postal_address, COMPANY_NAME: str_company_name, COMPANY_LOCATION_X: str_company_location_x, COMPANY_LOCATION_Y: str_company_location_y))
        //Method for obtaining data from the DB containing the address
        
    }//end of func
    
    
    func printDataArray() {
        let userLocation = Location(latitude: userLatitude, longitude: userLongitude)
        let nearestAddresses = findNearestAddresses(userLocation: userLocation, dataArray: dataArray)

        print("Printing nearest addresses")
        for (index, address) in nearestAddresses.enumerated() {
            print(index + 1, "번째 값 출력")
            print("업체 이름: ", address.COMPANY_NAME)
            print("업체 주소: ", address.COMPANY_ALL_ADDRESS)
            print("X 좌표: ", address.COMPANY_LOCATION_X)
            print("Y 좌표: ", address.COMPANY_LOCATION_Y, "\n")
        }//end of for
    }//end of printDataArray

    
    func calculateDistance(userLocation: Location, addressLocation: Location) -> Double {
        let earthRadius = 6371.0 // Earth's radius in kilometers
        
        let lat1Rad = userLocation.latitude * .pi / 180.0
        let lon1Rad = userLocation.longitude * .pi / 180.0
        let lat2Rad = addressLocation.latitude * .pi / 180.0
        let lon2Rad = addressLocation.longitude * .pi / 180.0
        
        let dlat = lat2Rad - lat1Rad
        let dlon = lon2Rad - lon1Rad
        
        let a = sin(dlat/2) * sin(dlat/2) + cos(lat1Rad) * cos(lat2Rad) * sin(dlon/2) * sin(dlon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let distance = earthRadius * c
        
        return distance
    }// end of calculateDistance
    
    func findNearestAddresses(userLocation: Location, dataArray: [Prescription]) -> [Prescription] {
        let sortedAddresses = dataArray.sorted { (prescription1, prescription2) -> Bool in
            let location1 = Location(latitude: prescription1.COMPANY_LOCATION_X, longitude: prescription1.COMPANY_LOCATION_Y)
            let location2 = Location(latitude: prescription2.COMPANY_LOCATION_X, longitude: prescription2.COMPANY_LOCATION_Y)
            
            let distance1 = calculateDistance(userLocation: userLocation, addressLocation: location1)
            let distance2 = calculateDistance(userLocation: userLocation, addressLocation: location2)
            
            return distance1 < distance2
        }//end of let
        
        let nearestAddresses = Array(sortedAddresses.prefix(15))
        
        return nearestAddresses
    }//end of findNearestAddresses
    
}//end of class

