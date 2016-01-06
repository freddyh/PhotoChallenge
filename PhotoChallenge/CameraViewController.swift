//
//  CameraChallengeViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit
import AVFoundation

//Ideas:
//Use Core Image to add filters
//avcapturevideodataoutput


/***
This is the initial view controller whose view is a feed from the camera
One tap will take a photo and open the photo in the ImageEditor
***/

class CameraViewController: UIViewController  {

    
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var captureButton: CameraCaptureButton!
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
		navigationController?.navigationBarHidden = true
		imageEditorViewController = ImageEditorViewController()
		imageEditorViewController.delegate = self
		
		
		/***
		Capture session coordinates the flow of data between inputs and outputs
		Session Preset is a capture setting for 1080p quality video
		1920pixels by 1080pixels
		***/
		captureSession = AVCaptureSession()
		captureSession?.sessionPreset = AVCaptureSessionPresetHigh
		
		let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		
		do {
			
			let input = try AVCaptureDeviceInput(device: backCamera)
			if ((captureSession?.canAddInput(input)) != nil) {
				captureSession?.addInput(input)
				
				/***
				Specify the type of output (still image) and format (jpeg)
				***/
				stillImageOutput = AVCaptureStillImageOutput()
				stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
				
				if captureSession?.canAddOutput(stillImageOutput) != nil {
					captureSession?.addOutput(stillImageOutput)
					
					/***
					Display video as it being captured by the input device
					Set the frame so the video fills the screen
					***/
					previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
					previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
					previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
					
					cameraView.layer.insertSublayer(previewLayer!, below: captureButton.layer)
					
				}
			}
		} catch let error {
			print("Error creating input with device: \(error)")
		}
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		previewLayer?.frame = cameraView.bounds
		captureSession?.startRunning()
	}
	
	@IBAction func switchCameraButtonTapped(sender: UIButton) {
		
		
		//Get a reference to current device and current camera position.
		//Toggle the position for next device
		let currentCameraInput = captureSession?.inputs.first as! AVCaptureDeviceInput
		let nextCameraPosition:AVCaptureDevicePosition = currentCameraInput.device.position == .Front ? .Back : .Front
		
		//Instantiate new device
		var nextCameraDevice:AVCaptureDevice?
		for device in AVCaptureDevice.devices() {
			if (device as! AVCaptureDevice).position == nextCameraPosition {
				nextCameraDevice = device as? AVCaptureDevice
			}
		}
		
		//Begin changing device input
		captureSession?.beginConfiguration()
		captureSession?.removeInput(currentCameraInput)
			
		do {
			let newCameraInput:AVCaptureDeviceInput = try AVCaptureDeviceInput(device: nextCameraDevice)
		
			if captureSession?.canAddInput(newCameraInput) != nil {
				captureSession?.addInput(newCameraInput)
			}
		} catch let error {
			print("Error while switching camera poisition: \(error)")
		}
		
		captureSession?.commitConfiguration()
		
	}
	
	@IBAction func tappedCaptureButton(sender: CameraCaptureButton) {
		
		if !isEditingPhoto {
			self.takePhoto()
			self.isEditingPhoto = true
		}
	}
	
	func takePhoto() {
		
		if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
			
			videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
			
			
			stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
				
				if sampleBuffer != nil {
					
                    /***
                     sampleBuffer contains data from the camera that is converted to UIImage
                     Pass the UIImage to the imageEditor
                    ***/
					let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
					let dataProvider = CGDataProviderCreateWithCFData(imageData)
					let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
					let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
					
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
		self.navigationController?.popViewControllerAnimated(false)
		isEditingPhoto = false
	}
}

extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func openPhotoLibrary(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] {
			
			self.imageEditorViewController.originalImage = image as! UIImage
			self.navigationController?.pushViewController(self.imageEditorViewController, animated: true)

        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
    }
}

