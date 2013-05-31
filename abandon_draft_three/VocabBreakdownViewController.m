//
//  VocabBreakdownViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/31/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "VocabBreakdownViewController.h"
#import "TestViewController.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"

@implementation VocabBreakdownViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionsError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionsError];
    [session setActive:YES error:nil];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[_vocabList valueForKey:@"recordingURL"]] error:nil];
    [_player setDelegate:self];
    [_player prepareToPlay];

    
    NSArray *wordList = [[_vocabList mutableSetValueForKey:@"wordsInList"] allObjects];
    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view addSubview:scroller];
    
    MGTableBoxStyled *topSection = MGTableBoxStyled.box;
    [scroller.boxes addObject:topSection];
    
    MGLineStyled *topRow = [MGLineStyled lineWithLeft:@"Play list" right:@"" size:(CGSize){304, 40}];
    [topRow setBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)101/255 blue:(float)136/255 alpha:1]];
    [topRow setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:18]];
    topRow.onTap = ^{
        [_player play];
    };
    
    [topSection.topLines addObject:topRow];
    
    MGTableBoxStyled *secondTopSection = MGTableBoxStyled.box;
    [scroller.boxes addObject:secondTopSection];

    
    MGLineStyled *secondTopRow = [MGLineStyled lineWithLeft:@"Test List" right:@"" size:(CGSize){304, 40}];
    [secondTopRow setBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:1]];
    [secondTopRow setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:18]];
    secondTopRow.onTap = ^{
        TestViewController *controller = [[TestViewController alloc] init];
        [controller setWordList:[[_vocabList mutableSetValueForKey:@"wordsInList"] allObjects]];
        
        [[self navigationController] pushViewController:controller animated:YES];

    };

    [secondTopSection.topLines addObject:secondTopRow];

    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    
    for (id word in wordList){
        
        MGLineStyled *row = [MGLineStyled lineWithLeft:[word valueForKey:@"chinese"]
                                                 right:[word valueForKey:@"english"] size:(CGSize){304, 40}];
        [row setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:18]];
        [section.topLines addObject:row];
        
    }
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    [scroller scrollToView:topSection withMargin:8];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
