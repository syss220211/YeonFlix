//
//  CoreUITest.swift
//  CoreManifests
//
//  Created by 박서연 on 11/26/25.
//

import UIKit
import SnapKit

public extension UIView {
    /// CoreUI가 제공하는 공통 레이아웃 Wrapper
    func pinEdgesToSuperview() {
        guard superview != nil else {
            print("Superview가 없습니다.")
            return
        }

        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
