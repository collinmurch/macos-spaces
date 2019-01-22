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
    
    public var count: Int64 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clicked(_ sender: Any) {
        count += 1
        
        if count >= 5 {
            count = 1
        }
        
        label.stringValue = String(count)
        
        var text: String = ""
        
        switch count{
            case 2:
                text = "1 ② 3 4"
            case 3:
                text = "1 2 ③ 4"
            case 4:
                text = "1 2 3 ④"
            default:
                text = "① 2 3 4"
        }
        
        ad?.update(text)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
