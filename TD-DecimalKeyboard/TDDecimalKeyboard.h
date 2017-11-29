//
//  TDCustomKeyboard.h
//  TD-DecimalKeyboard
//
//  Created by Babak Samareh on 2017-11-24.
//  Copyright © 2017 touchDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TDDecimalKeyboard : NSObject
{
    UIWindow                *window;
    UIView                  *blackMask;
    UITextField             *hostTextField;
    UILabel                 *accessoryTextField;
    UIView                  *keyboard;
}

// Public properties
@property(nonatomic)        BOOL                    enableAccessoryView;
@property(nonatomic)        float                   screenTint;
@property(nonatomic)        UIColor                 *keyboardTint;
@property(nonatomic)        UIColor                 *highlightTint;

// Public methods
- (void)attachKeyboardToTextField:(UITextField *)textField;
- (void)closeCustomKeyboards;

@end
