//
//  ViewController.h
//  TD-CustomKeyboard
//
//  Created by Babak Samareh on 2017-11-24.
//  Copyright © 2017 touchDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCustomKeyboard.h"

@interface ViewController : UIViewController
{
    // Keyboard instance
    TDCustomKeyboard *customKeyboard;
}

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@end

