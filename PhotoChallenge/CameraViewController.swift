//
//  CameraViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit
import AVFoundation

/***
This is the initial view controller whose view is a feed from the camera
One tap will take a photo and open the photo in the ImageEditor
***/

class CameraViewController: UIViewController  {

    
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var captureButton: CaptureButton!
	@IBOutlet weak var switchCameraButton: UIButton!
	
    /***
     AVFoundation Properties
    ***/
	var captureSession: AVCaptureSession?
	var stillImageOutput: AVCaptureStillImageOutput?
	var previewLayer: AVCaptureVideoPreviewLayer?
    
    var isEditingPhoto: Bool = false
	var imageEditorViewController: ImageEditorViewController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
		imageEditorViewController = ImageEditorViewController()
		imageEditorViewController.delegate = self
		
		
		/***
		Capture session coordinates the flow of data between inputs and outputs
		Session Preset is a capture setting for 1080p quality video
		1920x1080 pixels front camera
		720x?pixelsfor back camera
		***/
		captureSession = AVCaptureSession()
		captureSession?.sessionPreset = AVCaptureSession.Preset(rawValue: convertFromAVCaptureSessionPreset(AVCaptureSession.Preset.high))
		
        let backCamera = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        do {
            
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if ((captureSession?.canAddInput(input)) != nil) {
                captureSession?.addInput(input)
                
                /***
                 Specify the type of output (still image) and format (jpeg)
                 ***/
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                
                if captureSession?.canAddOutput(stillImageOutput!) != nil {
                    captureSession?.addOutput(stillImageOutput!)
                    
                    /***
                     Display video as it being captured by the input device
                     Set the frame so the video fills the screen
                     ***/
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                    previewLayer?.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspect))
                    previewLayer?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    cameraView.layer.insertSublayer(previewLayer!, below: captureButton.layer)
                    
                }
            }
        } catch let error {
            print("Error creating input with device: \(error)")
        }
    }
	
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		previewLayer?.frame = cameraView.bounds
		captureSession?.startRunning()
	}
	
	@IBAction func switchCameraButtonTapped(_ sender: UIButton) {
		
		//Get a reference to current device and current camera position.
		//Toggle the position for next device
		let currentCameraInput = captureSession?.inputs.first as! AVCaptureDeviceInput
        let nextCameraPosition:AVCaptureDevice.Position = currentCameraInput.device.position == .front ? .back : .front
		
		//Instantiate new device from array of devices with correct camera position
		var nextCameraDevice:AVCaptureDevice?
		for device in AVCaptureDevice.devices() {
			if (device ).position == nextCameraPosition {
				nextCameraDevice = device
			}
		}
		
		//Begin changing device input
		captureSession?.beginConfiguration()
		captureSession?.removeInput(currentCameraInput)
			
		do {
            let newCameraInput:AVCaptureDeviceInput = try AVCaptureDeviceInput(device: nextCameraDevice!)
		
			if captureSession?.canAddInput(newCameraInput) != nil {
				captureSession?.addInput(newCameraInput)
			}
		} catch let error {
			print("Error while switching camera poisition: \(error)")
		}
		
		captureSession?.commitConfiguration()
		
	}
	
    @IBAction func captureButtonTapped(_ sender: CaptureButton) {		
		if !isEditingPhoto {
			self.takePhoto()
			self.isEditingPhoto = true
		}
	}
	
	func takePhoto() {
		
        if let videoConnection = stillImageOutput?.connection(with: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) {
			
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
			
			
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
				
				if sampleBuffer != nil {
					
                    /***
                     sampleBuffer contains NSData, convert it to UIImage
                     Pass the UIImage to the imageEditor
                    ***/
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImage.Orientation.right)
					
					self.imageEditorViewController.originalImage = image
					self.navigationController?.pushViewController(self.imageEditorViewController, animated: false)
					
					self.captureSession?.stopRunning()
				}
			})
		}
	}
}

extension CameraViewController : ImageEditorDelegate {
	
	func imageEditorDidCancel() {
        self.navigationController?.popViewController(animated: false)
		isEditingPhoto = false
	}
}

extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        dismiss(animated: true, completion: nil)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] {
			
            self.imageEditorViewController.originalImage = (image as! UIImage)
			self.navigationController?.pushViewController(self.imageEditorViewController, animated: true)

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVCaptureSessionPreset(_ input: AVCaptureSession.Preset) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
