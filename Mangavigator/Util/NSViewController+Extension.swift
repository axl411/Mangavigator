//
//  NSViewController+Extension.swift
//  Mangavigator
//
//  Created by Gu Chao on 2018/08/28.
//  Copyright © 2018 Gu Chao. All rights reserved.
//

import Cocoa

extension NSViewController {
    enum ChildViewLayout {
        case fill
    }

    func addChildViewController(_ childViewController: NSViewController, childViewLayout: ChildViewLayout) {
        addChild(childViewController)
        let childView = childViewController.view
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
