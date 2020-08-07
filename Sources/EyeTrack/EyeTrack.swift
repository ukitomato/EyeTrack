//
//  EyeTrack.swift
//
//
//  Created by Yuki Yamato on 2020/08/07.
//

import UIKit
import ARKit


let IS_BLINK_THRESHOLD: Float = 0.4
let SMOOTHING_RANGE: Int = 10

class EyeTrack {
    var bufferLookAtPosition: [CGPoint] = []
    var lookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    var lookAtPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var device: Device
    var face: Face

    init(type: DeviceType) {
        self.device = Device(type: type)
        self.face = Face()
    }

    // SceneViewと紐つける
    func registerSceneView(sceneView: ARSCNView) {
        sceneView.scene.rootNode.addChildNode(self.face.node)
        sceneView.scene.rootNode.addChildNode(self.device.node)
    }

    // ARFaceAnchorを基に情報を更新
    func update(anchor: ARFaceAnchor) {
        // 顔座標更新(眼球座標更新)
        self.face.update(anchor: anchor)
        // 瞬き判定
        if self.face.leftEye.blink > IS_BLINK_THRESHOLD {
            print("Close")
        } else {
            updateLookAtPosition()
        }
    }

    // 視点位置更新
    func updateLookAtPosition() {
        let rightEyeHittingAt = self.face.rightEye.hittingAt(device: device)
        let leftEyeHittingAt = self.face.leftEye.hittingAt(device: device)
        let lookAt = CGPoint(x: (rightEyeHittingAt.x + leftEyeHittingAt.x) / 2, y: -(rightEyeHittingAt.y + leftEyeHittingAt.y) / 2)
        self.bufferLookAtPosition.append(lookAt)
        self.lookAtPosition = Array(self.bufferLookAtPosition.suffix(SMOOTHING_RANGE)).average!
        self.lookAtPoint = CGPoint(x: self.lookAtPosition.x + self.device.screenPointSize.width / 2, y: self.lookAtPosition.y + self.device.screenPointSize.height / 2)
    }

}
