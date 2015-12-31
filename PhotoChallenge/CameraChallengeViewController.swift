//
//  CameraChallengeViewController.swift
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

class CameraChallengeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
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
	var imageEditorView: ImageEditor!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		/***
		Capture session coordinates the flow of data between inputs and outputs
		Session Preset is a capture setting for 1080p quality video
		1920pixels by 1080pixels
		***/
		captureSession = AVCaptureSession()
		captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
		
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
		print("toggle Camera POsition")
		//create new device
		//create new device input
		//session.beginConfig
		//remove old deviceinput from session
		//set session preset again
		//device supports preset?
		//device lockConfiguration?
		//if canAdd then add
		//session.commitConfig
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
					
					self.imageEditorView = ImageEditor(sourceView: self.view, originalImage: image)
					self.imageEditorView.delegate = self
				}
			})
		}
	}

}

extension CameraChallengeViewController : ImageEditorDelegate {
	
	func imageEditorDidCancel() {
		imageEditorView = nil
		isEditingPhoto = false
	}
		
	func imageEditorDidSaveImage(image:UIImage) {
		self.showSavedPhotoAlert(image)
	}
	
	func showSavedPhotoAlert(image:UIImage) {
		
        /***
         Show an alert that confirms the photo was saved and give an option to share the photo
         If user pressed "Share" then the image is passed to a UIActivityViewController
        ***/
		let successAlert = UIAlertController(title: "Successfully Saved", message: "There is a new photo in your library.", preferredStyle: .Alert)
		let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		let shareAction = UIAlertAction(title: "Share", style: .Default, handler: { _ in self.showShareMenu(image)})
        
		successAlert.addAction(doneAction)
		successAlert.addAction(shareAction)
		
		presentViewController(successAlert, animated: true, completion: nil)
	}
	
	func showShareMenu(image:UIImage) {
		
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		presentViewController(activityController, animated: true, completion: nil)
	}
}