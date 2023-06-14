//
//  ImageSubViewController.swift
//  Wemo_
//
//  Created by 김양현 on 2023/06/05.
//

import UIKit
import VisionKit
import Vision

class ImageSubViewController: UIViewController {
    
    
    @IBOutlet var img_select: UIImageView!
    
    
    @IBOutlet var label_select_img: UILabel!
    
    var sendSelectImg : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        img_select.image = sendSelectImg
        
        
        recognizeText(image:img_select.image)
    
    }//end of viewDidLoad
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        img_select.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
        
        label_select_img.frame = CGRect(
            x: 20,
            y: view.frame.size.width + view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: 300)
    }//end of viewDidLayoutSubviews
    
    fileprivate func recognizeText(image: UIImage?){
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }//end of guard let cgImage
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest{ [weak self]request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }//end of guard let observations
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            
            DispatchQueue.main.async {
                self?.label_select_img.text = text
            }//end of DispatchQueue
        }//end of let request
        
        if #available(iOS 16.0, *) {
            let revision3 = VNRecognizeTextRequestRevision3
            request.revision = revision3
            request.recognitionLevel = .accurate
            request.recognitionLanguages =  ["ko-KR"]
            request.usesLanguageCorrection = true
            
            do {
                var possibleLanguages: Array<String> = []
                possibleLanguages = try request.supportedRecognitionLanguages()
                print(possibleLanguages)
            } catch {
                print("Error getting the supported languages.")
            }//end of do catch
        } else {
            // Fallback on earlier versions
            request.recognitionLanguages =  ["en-US"]
            request.usesLanguageCorrection = true
        }//end of else if
        
        do{
            try handler.perform([request])
        } catch {
            label_select_img.text = "\(error)"
            print(error)
        }//end of do catch
    }//end of recognizeText
    
    
}//end of class
