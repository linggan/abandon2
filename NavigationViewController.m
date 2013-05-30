//
//  NavigationViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/5/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "NavigationViewController.h"
#import "FlatLabel.h"
#import "RecordViewController.h"
#import "VocabViewController.h"
#import "CGCViewController.h"


@implementation NavigationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self navigationBar]setTintColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.56]];
    [[self navigationBar]setTintColor:[UIColor colorWithRed:(float)124/255 green:(float)124/255 blue:(float)124/255 alpha:0.56]];

    __typeof (&*self) __weak weakSelf = self;

    
    FlatLabel *record = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"record new words" andBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)101/255 blue:(float)136/255 alpha:1]];
    FlatLabel *vocab = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"vocabulary lists" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:1]];
    FlatLabel *practice = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"test memory" andBackgroundColor:[UIColor colorWithRed:(float)219/255 green:(float)231/255 blue:(float)219/255 alpha:1]];


    REMenuItem *recordItem = [[REMenuItem alloc] initWithCustomView:record action:^(REMenuItem *item){
        RecordViewController *controller = [[RecordViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [controller setWordList:[[controller dataDelegate] getAllUnrecordedWordsinQueue]];
        [weakSelf pushViewController:controller animated:YES];}];
    
    REMenuItem *vocabItem = [[REMenuItem alloc] initWithCustomView:vocab action:^(REMenuItem *item){
        VocabViewController *controller = [[VocabViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [weakSelf pushViewController:controller animated:YES];
    }];
    
    REMenuItem *reviewItem = [[REMenuItem alloc] initWithCustomView:practice action:^(REMenuItem *item){
        CGCViewController *controller = [[CGCViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [weakSelf pushViewController:controller animated:YES];}];


    _menu = [[REMenu alloc] initWithItems:@[recordItem, vocabItem, reviewItem]];
    [_menu setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [_menu setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [_menu setSeparatorHeight:0];
     
}



- (void)toggleMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    [_menu showFromNavigationController:self];
}
@end
