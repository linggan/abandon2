//
//  BubbleGameViewController.h
//  abandon_draft_three
//
//  Created by Carl G Cota-Robles on 5/11/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataDelegate.h"

@interface BubbleGameViewController : UIViewController

@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;
@property (weak, nonatomic) IBOutlet UILabel *englishDefinition;
@property (weak, nonatomic) IBOutlet UIImageView *definitionImage;
@property (weak, nonatomic) IBOutlet UILabel *timerDisplay;
@property (weak, nonatomic) IBOutlet UILabel *popUpStatus;

@property (weak, nonatomic) IBOutlet UIImageView *instructions;

- (IBAction)closeInstructions:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;

@property (nonatomic) NSInteger showInstructions;

@property (nonatomic, strong) NSArray *wordList;
@property (nonatomic) NSInteger counter;
@property (nonatomic) Boolean stopTimer;

@property (nonatomic) NSInteger wordListTracker;

-(void)compareAnswer: (NSNotification*)notification;

-(void)exitWithFailure;
-(void)exitWithSuccess;

-(void)erasePopUpStatus;

@end
