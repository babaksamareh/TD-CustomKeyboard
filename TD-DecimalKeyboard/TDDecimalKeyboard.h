//
//  TDCustomKeyboard.h
//  TD-DecimalKeyboard
//
//  Created by Babak Samareh on 2017-11-24.
//  Copyright © 2017 touchDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Keyboard style
typedef NS_ENUM(NSInteger, TDKeyboardStyle)
{
    TDKeyboardStyleLight,
    TDKeyboardStyleDark
};

@interface TDDecimalKeyboard : NSObject
{
    UIWindow                *window;
    UIView                  *blackMask;
    UITextField             *hostTextField;
    UILabel                 *accessoryTextField;
    UIView                  *keyboard;
}

// Public properties
@property(nonatomic)        BOOL                    enableAccessoryView;        // Default is NO
@property(nonatomic)        float                   screenTint;                 // Default if 0.4
@property(nonatomic)        UIColor                 *keyboardTint;              // Default is (57, 127, 243)
@property(nonatomic)        TDKeyboardStyle         keyboardStyle;              // default is TDKeyboardStyleLight

// Public methods
- (void)attachKeyboardToTextField:(UITextField *)textField;
- (void)closeCustomKeyboards;

@end
