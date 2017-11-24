//
//  ViewController.h
//  TD-DecimalKeyboard
//
//  Created by Babak Samareh on 2017-11-24.
//  Copyright © 2017 touchDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDDecimalKeyboard.h"

@interface ViewController : UIViewController
{
    // Keyboard instance
    TDDecimalKeyboard *decimalKeyboard;
}

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@end

