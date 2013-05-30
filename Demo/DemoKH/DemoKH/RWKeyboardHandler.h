//
//  RWKeyboardHandler.h
//  DemoKH
//
//  Created by Den on 5/26/13.
//  Copyright (c) 2013 Den. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWKeyboardHandlerDelegate <NSObject>
//Called when the button is clicked "return" to the last UITextField in the hierarchy.
- (void)lastTextFieldShouldReturn;
@end

@interface RWKeyboardHandler : UIScrollView <UITextFieldDelegate> {
    NSMutableArray * textFields; //all found UITextField's
    UITextField *activeTextField; //current active UITextField
    CGRect initialRect; //initial UIScrollView rect
}

@property (nonatomic, assign) id<RWKeyboardHandlerDelegate> keyboardDelegate;

//close active keyboard
- (void)closeKeyboard;

@end
