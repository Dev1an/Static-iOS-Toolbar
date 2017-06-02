//
//  ViewController.swift
//  RotatingToolbar
//
//  Created by Damiaan on 2/06/17.
//  Copyright © 2017 Damiaan Dufaux. All rights reserved.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController {
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var toolbar: UIToolbar!
	var orientation: UIDeviceOrientation { return UIDevice.current.orientation }
	var observer: AnyObject?

	override var shouldAutorotate: Bool { return false }
	
	func orientationChanged(_ notification: Notification) {
		let rotation = CGAffineTransform(rotationAngle: self.orientation.angle)
		let size: CGSize
		if orientation.isLandscape {
			size = CGSize(width: UIScreen.main.bounds.size.height - 20, height: UIScreen.main.bounds.size.width)
		} else {
			size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 20)
		}
		UIView.animate(withDuration: CATransaction.animationDuration()) {
			self.image.transform = rotation
			self.image.frame.size = size
			self.image.bounds.size = size
			self.image.frame.origin = CGPoint(x: 0, y: 20)
			
			for item in self.toolbar.items!.flatMap({$0.customView}) {
				item.transform = rotation
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		observer = NotificationCenter.default.addObserver(forName: .UIDeviceOrientationDidChange, object: nil, queue: nil, using: orientationChanged)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let observer = observer {
			NotificationCenter.default.removeObserver(observer)
		}
	}
}

extension UIDeviceOrientation {
	var angle: CGFloat {
		switch self {
		case .faceUp, .faceDown, .portrait, .unknown:
			return 0
		case .portraitUpsideDown:
			return .pi
		case .landscapeLeft:
			return .pi/2
		case .landscapeRight:
			return -.pi/2
		}
	}
}
