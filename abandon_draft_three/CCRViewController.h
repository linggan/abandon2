//
//  CCRViewController.h
//  MemoryProject
//
//  Created by Carl G Cota-Robles on 4/29/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRMemoryCardCell.h"
#import "CoreDataDelegate.h"

@interface CCRViewController : UIViewController //The View Controller for the Memory Game

@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *matchingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property(nonatomic, strong) NSArray *wordList;
@property (nonatomic) NSMutableArray *allBlueCards;
@property (nonatomic) NSMutableArray *allRedCards;

@property (nonatomic) NSObject *cellClassLookingFor;
@property (nonatomic) CCRMemoryCardCell *prevCell;
@property (nonatomic) NSInteger totalMatched;

@property (nonatomic) NSInteger *counter;
@property (nonatomic) Boolean stopTimer;
@property (nonatomic) Boolean inProgress;

-(void)respondToLooking:(NSNotification*)notification; //this method compares two cards to see if they're a match

-(void)exitWithFailure;
-(void)exitWithWinning;

-(void)eraseMatchingLabel;
-(void)enableUserInteraction;

@end
