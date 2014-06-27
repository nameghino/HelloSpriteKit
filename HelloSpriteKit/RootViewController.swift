//
//  RootViewController.swift
//  HelloSpriteKit
//
//  Created by Nicolas Ameghino on 6/13/14.
//  Copyright (c) 2014 Nicolas Ameghino. All rights reserved.
//

import UIKit
import SpriteKit

class RootViewController: UIViewController {
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skview = self.view as SKView
        skview.showsDrawCount = true
        skview.showsFPS = true
        skview.showsNodeCount = true
        
        skview.backgroundColor = UIColor.purpleColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        let scene = PlaygroundScene(size: CGSizeMake(768, 1024))
        (self.view as SKView).presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool { return true }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
