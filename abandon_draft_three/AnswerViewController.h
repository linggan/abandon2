//
//  AnswerViewController.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/29/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"
#import "Word.h"

@interface AnswerViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userAnswer;
@property (weak, nonatomic) IBOutlet UILabel *answer;
@property (weak, nonatomic) IBOutlet UILabel *pinyin;
@property (weak, nonatomic) IBOutlet UILabel *english;
@property (strong, nonatomic) Word *word;
@property (nonatomic, assign) id<ModalViewDelegate> modalDelegate;

@end
