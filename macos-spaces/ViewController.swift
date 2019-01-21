//
//  ViewController.swift
//  macos-spaces
//
//  Created by Collin Murch on 1/20/19.
//  Copyright © 2019 collinmurch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet var window: NSView!
    
    let ad = NSApplication.shared.delegate as? AppDelegate
    
    public var count: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clicked(_ sender: Any) {
        count += 1
        
        label.stringValue = String(count)
        ad?.update(String(count))
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

