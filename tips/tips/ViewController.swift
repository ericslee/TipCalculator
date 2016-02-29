//
//  ViewController.swift
//  tips
//
//  Created by ericslee on 2/28/16.
//  Copyright © 2016 ericcodepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Store a reference to this view controller in the app delegate.
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.mainViewController = self

    tipLabel.text = "$0.00"
    totalLabel.text = "$0.00"

    // Remember the bill amount across app restarts if it has been <10 min since
    // app restart. If it has been >10 min, the stored bill amount will have been
    // overwritten to zero.
    let defaults = NSUserDefaults.standardUserDefaults()
    if let savedBill = defaults.objectForKey(kLastBillAmount) {
      billField.text = savedBill as? String
      onEditingChanged(billField)
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    let defaults = NSUserDefaults.standardUserDefaults()
    let intValue = defaults.integerForKey(kDefaultTip)
    tipControl.selectedSegmentIndex = intValue
  }

  @IBAction func onEditingChanged(sender: AnyObject) {
    var tipPercentages = [0.18, 0.2, 0.25]
    let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]

    let billAmount = (billField.text! as NSString).doubleValue
    let tip = billAmount * tipPercentage
    let total = billAmount + tip

    tipLabel.text = String(format: "$%.2f", tip)
    totalLabel.text = String(format: "$%.2f", total)
  }

  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }
}

