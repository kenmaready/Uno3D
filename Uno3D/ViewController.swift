//
//  ViewController.swift
//  Uno3D
//
//  Created by Ken Maready on 8/14/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let images = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main) {
            configuration.trackingImages = images
            configuration.maximumNumberOfTrackedImages = 5
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height
            )
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi / 2
            node.addChildNode(planeNode)
            
            var imageFileName: String
            var imageScale: SCNVector3
            var imageXRotation: Float
            var imageZRotation: Float

            switch anchor.name! {
            case "yellow_3":
                imageFileName = "Dragon 2.5"
                imageScale = SCNVector3(0.15, 0.15, 0.15)
                imageXRotation = Float.pi / 2
                imageZRotation = 0.0
            case "yellow_2":
                imageFileName = "Spyro_The_Dragon"
                imageScale = SCNVector3(0.0003, 0.0003, 0.0003)
                imageXRotation = Float.pi
                imageZRotation = Float.pij
            default:
                return node
            }
            
            let dragonScene = SCNScene(named: "art.scnassets/\(imageFileName).scn")!
            let dragonNode = dragonScene.rootNode.childNodes.first!
            dragonNode.scale = imageScale
            dragonNode.eulerAngles.x = imageXRotation
            dragonNode.eulerAngles.z = imageZRotation
            planeNode.addChildNode(dragonNode)
        }
    
        return node
    }
}
