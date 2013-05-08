//
//  RootViewController.h
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCharacterScreenViewController.h"
#import "CoreDataDelegate.h"
#import "REMenu.h"


@protocol RootViewControllerDelegate <NSObject>
-(void)callNewScreen: (NSString *)screenName;
@end

@interface RootViewController : UIViewController <UITextFieldDelegate, ModalViewDelegate>
@property UIButton *goToWordBankBtn;
@property UIButton *goToAboutPageBtn;
@property (weak, nonatomic) IBOutlet UITextField *WordInputField;
@property (nonatomic, assign) id<RootViewControllerDelegate> delegate;
@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;
@property (strong, nonatomic) REMenu *menu;

- (void)attemptToAddInputToDatabase:(NSString *)word;

@end
