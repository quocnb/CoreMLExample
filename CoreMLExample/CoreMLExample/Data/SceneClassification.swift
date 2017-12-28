//
//  SceneClassification.swift
//  CoreMLExample
//
//  Created by Quoc Nguyen on 12/28/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
//

import Foundation

enum SceneType {
    case forest
    case beach
    case other

    init(classification: String) {
        switch classification {
        case "ocean", "playground":
            self = .beach
        case "rainforest", "forest_path", "bamboo_forest", "forest_road", "tree_farm", "rope_bridge", "mountain_snowy":
            self = .forest
        default:
            self = .other
        }
    }
}

extension SceneType: Equatable { }
