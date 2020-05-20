//
//  MapMountainPoint.swift
//  Geo
//
//  Created by Иван Алексеев on 18.05.2020.
//  Copyright © 2020 NETTRASH. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

enum MountainType {
	case HIGHEST
	case SEVEN_PEAKS
	case SNOW_LEOPARD_OF_RUSSIA
}

open class MapMountainPoint: MapPointBase {
	
	private var mMountain: MountainInfo
	private var mMountainType: MountainType
	override public var identifier: String {
		get {
			switch mMountainType {
			case .HIGHEST:
				return "MapMountainHighestPointAnnotationView"
			case .SEVEN_PEAKS:
				return "MapMountainSevenPeaksPointAnnotationView"
			case .SNOW_LEOPARD_OF_RUSSIA:
				return "MapMountainSnowLeopardPointAnnotationView"
			}
		}
	}
	override public var tintColor: UIColor {
		get {
			switch mMountainType {
			case .HIGHEST:
				return .black
			case .SEVEN_PEAKS:
				return .darkGray
			case .SNOW_LEOPARD_OF_RUSSIA:
				return .white
			}
		}
	}
	override public var iconImage: UIImage? {
		get {
			switch mMountainType {
			case .HIGHEST:
				return UIImage(named: "MapMountainPoint")
			case .SEVEN_PEAKS:
				return UIImage(named: "MapMountainSevenPeaksPoint")
			case .SNOW_LEOPARD_OF_RUSSIA:
				return UIImage(named: "MapMountainSnowLeopardPoint")
			}
		}
	}

	init(mountain: MountainInfo, type mountainType: MountainType) {
		mMountain = mountain
		mMountainType = mountainType
	}
}

extension MapMountainPoint : MKAnnotation {
	
	//MKAnnotqation
	public var coordinate: CLLocationCoordinate2D {
		get {
			return
				CLLocationCoordinate2D(
					latitude: (mMountain.coordinates?.latitude)!,
					longitude: (mMountain.coordinates?.longitude)!)
		}
	}
	
	public var title: String? {
		get {
			return mMountain.name
		}
	}
	
	public var subtitle: String? {
		get {
			switch mMountainType {
			case .HIGHEST:
				var summitInfo = ""
				if (mMountain.firstAscent ?? "" == "") {
					summitInfo = NSLocalizedString("MountainNoSummit", comment: "")
				} else {
					summitInfo = String(format: NSLocalizedString("MountainSummit", comment: ""), mMountain.firstAscent!)
				}
				return String(format: NSLocalizedString("MountainDetails", comment: ""), mMountain.height!, summitInfo)
			case .SEVEN_PEAKS:
				return String(format: NSLocalizedString("MountainDetails", comment: ""), mMountain.height!, "(\(mMountain.location ?? ""))")
			case .SNOW_LEOPARD_OF_RUSSIA:
				return String(format: NSLocalizedString("MountainDetails", comment: ""), mMountain.height!, "(\(mMountain.location ?? ""))")
			}
		}
	}
	
}
