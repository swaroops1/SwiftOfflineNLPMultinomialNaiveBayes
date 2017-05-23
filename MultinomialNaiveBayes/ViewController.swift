//
//  ViewController.swift
//  MultinomialNaiveBayes
//
//  Created by Sridhar, Swaroop (US - Bengaluru) on 22/05/17.
//  Copyright © 2017 Sridhar, Swaroop (US - Bengaluru). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var bayesHelper = BayesHelper()
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bayesHelper.prepareDataForWeights()
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnCheckTappe(_ sender: Any) {
        let classifyResult = bayesHelper.classify(sentence: questionField.text!)
        self.lblResult.text = String("Class : "+classifyResult.class+" |  Weight: "+String(classifyResult.weight))
    }

}

