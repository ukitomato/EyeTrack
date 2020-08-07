//
//  EyeTrackViewController.swift
//  
//
//  Created by Yuki Yamato on 2020/08/07.
//


import UIKit
import ARKit

class EyeTrackViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    var eyeTrackSceneView: ARSCNView!

    var eyeTrack = EyeTrack(type: DeviceType.iPhone)

    let arConfiguration = ARFaceTrackingConfiguration()

    func setup() {
        let frame = super.view.frame
        // Initialize ARSCNView
        eyeTrackSceneView = ARSCNView(frame: frame)
        self.view.addSubview(eyeTrackSceneView!)

        // Set the view's delegate
        eyeTrackSceneView.delegate = self
        eyeTrackSceneView.session.delegate = self
        eyeTrackSceneView.isHidden = true

        eyeTrackSceneView.automaticallyUpdatesLighting = true

        // Register EyeTrack module
        eyeTrack.registerSceneView(sceneView: eyeTrackSceneView)
    }
    
    func setup(sceneView: ARSCNView) {
        // Initialize ARSCNView
        eyeTrackSceneView = sceneView
        self.view.addSubview(eyeTrackSceneView!)

        // Set the view's delegate
        eyeTrackSceneView.delegate = self
        eyeTrackSceneView.session.delegate = self
        eyeTrackSceneView.isHidden = true

        eyeTrackSceneView.automaticallyUpdatesLighting = true

        // Register EyeTrack module
        eyeTrack.registerSceneView(sceneView: eyeTrackSceneView)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up SceneKit
        setup()
        // or Set up with your own sceneView
        // setup(sceneView: mySceneView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("ARFaceTrackingConfiguration Error.")
        }
       
        arConfiguration.isLightEstimationEnabled = true

        // Run the view's session
        eyeTrackSceneView.session.run(arConfiguration, options: [.resetTracking, .removeExistingAnchors])
 
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        eyeTrackSceneView.session.pause()

    }

    // MARK: - ARSCNViewDelegate


    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

    // Update Some View when updating Face Anchor
    func updateViewWithUpdateAnchor() {
    }
}


extension EyeTrackViewController {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        eyeTrack.face.node.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        updateAnchor(withFaceAnchor: faceAnchor)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let sceneTransformInfo = eyeTrackSceneView.pointOfView?.transform else {
            return
        }
        // Update Virtual Device position
        eyeTrack.device.node.transform = sceneTransformInfo
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        eyeTrack.face.node.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        updateAnchor(withFaceAnchor: faceAnchor)
    }

    func updateAnchor(withFaceAnchor anchor: ARFaceAnchor) {
        DispatchQueue.main.async {
            self.eyeTrack.update(anchor: anchor)
            self.updateViewWithUpdateAnchor()
        }
    }

//    func getUIImage() {
//        let buffer: CVPixelBuffer = self.eyeTrackSceneView.session.currentFrame!.capturedImage
//        let ciImage = CIImage(cvPixelBuffer: buffer)
//        let temporaryContext = CIContext(options: nil)
//        if let temporaryImage = temporaryContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))) {
//            let image = UIImage(cgImage: temporaryImage)
//            print(self.getByteArrayFromImage(imageRef: image.cgImage!).count)
//        }
//    }
//
//    func getByteArrayFromImage(imageRef: CGImage) -> [UInt8] {
//        let data = imageRef.dataProvider!.data
//        let length = CFDataGetLength(data)
//        var rawData = [UInt8](repeating: 0, count: length)
//        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
//        return rawData
//    }
}


