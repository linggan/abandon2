//
//  CharacterInfoViewController.h
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/2/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"

@protocol CharacterInfoViewControllerDelegate <NSObject>
- (void)didDismissPresentedViewController;
@end


@interface CharacterInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *chinese;
@property (weak, nonatomic) IBOutlet UILabel *pinyin;
@property (weak, nonatomic) IBOutlet UILabel *english;
@property (retain, nonatomic) NSArray *word;
@property (nonatomic, assign) id<ModalViewDelegate> modalDelegate;


- (IBAction)dismissScreen:(id)sender;

@end
