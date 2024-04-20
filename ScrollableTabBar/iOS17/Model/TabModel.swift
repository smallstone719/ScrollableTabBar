//
//  TabModel.swift
//  ScrollableTabBar
//
//  Created by Thach Nguyen Trong on 4/20/24.
//

import Foundation

struct TabModel: Identifiable {
    private (set) var id: Tab
    var size: CGSize        = .zero
    var minX: CGFloat       = .zero
    
    enum Tab: String, CaseIterable {
        case research       = "Research"
        case deployment     = "Deployment"
        case analytics      = "Analytics"
        case audience       = "Audience"
        case privacy        = "Privacy"
    }
}
