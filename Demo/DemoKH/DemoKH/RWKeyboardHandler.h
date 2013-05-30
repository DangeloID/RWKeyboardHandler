//
//  RWKeyboardHandler.h
//  DemoKH
//
//  Created by Den on 5/26/13.
//  Copyright (c) 2013 Den. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWKeyboardHandlerDelegate <NSObject>
@optional
- (void)lastTextFieldShouldReturn;
@end

@interface RWKeyboardHandler : UIScrollView <UITextFieldDelegate> {
    NSMutableArray * textFields;
    UITextField *activeTextField;
    CGRect initialRect;
}

@property (nonatomic, assign) id<RWKeyboardHandlerDelegate> keyboardDelegate;

- (void)closeKeyboard;
- (void)reinitialize;

@end
