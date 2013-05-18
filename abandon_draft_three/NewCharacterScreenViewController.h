//
//  NewCharacterScreenViewController.h
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/2/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"


@interface NewCharacterScreenViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UILabel *chinese;
@property (weak, nonatomic) IBOutlet UILabel *pinyin;
@property (weak, nonatomic) IBOutlet UILabel *english;
@property (retain, nonatomic) NSArray *word;
- (IBAction)dismissScreen:(id)sender;

@property (nonatomic, assign) id<ModalViewDelegate> modalDelegate;


@end
