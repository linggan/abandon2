//
//  AnswerViewController.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/29/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"

@interface AnswerViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *answer;
@property (strong, nonatomic) NSString *text;
@property (nonatomic, assign) id<ModalViewDelegate> modalDelegate;

@end
