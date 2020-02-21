//
//  CameraModel.swift
//  Kiwi
//
//  Created by Brandon Guerra on 1/28/20.
//  Copyright © 2020 Brandon Guerra. All rights reserved.
//

enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

enum CameraPosition {
    case front
    case rear
}
