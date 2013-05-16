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
#import "VocabExportViewController.h"
#import "CGCViewController.h"
#import "CCRViewController.h"
#import "BubbleGameViewController.h"


@implementation NavigationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self navigationBar]setTintColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.56]];
    [[self navigationBar]setTintColor:[UIColor colorWithRed:(float)124/255 green:(float)124/255 blue:(float)124/255 alpha:0.56]];

    __typeof (&*self) __weak weakSelf = self;

    
    FlatLabel *record = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"record new words" andBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)101/255 blue:(float)136/255 alpha:1]];
    FlatLabel *export = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"export vocabulary" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:1]];
    FlatLabel *practice = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"practice writing" andBackgroundColor:[UIColor colorWithRed:(float)219/255 green:(float)231/255 blue:(float)219/255 alpha:1]];
    FlatLabel *playMemory = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"play memory game" andBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)231/255 alpha:1]];
    FlatLabel *playBubbles = [FlatLabel FlatLabelWithFrame:CGRectMake(0,0,320,44) WithText:@"play bubble game" andBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];


    REMenuItem *recordItem = [[REMenuItem alloc] initWithCustomView:record action:^(REMenuItem *item){
        RecordViewController *controller = [[RecordViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [controller setWordList:[[controller dataDelegate] getAllUnrecordedWordsinQueue]];
        [weakSelf pushViewController:controller animated:YES];}];
    
    REMenuItem *exportItem = [[REMenuItem alloc] initWithCustomView:export action:^(REMenuItem *item){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Vocab List" message:@"Give it a nice name, yeah?" delegate:self cancelButtonTitle:@"Nah" otherButtonTitles:@"Okay", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeAlphabet;
        [alert show];
    }];
    
    REMenuItem *reviewItem = [[REMenuItem alloc] initWithCustomView:practice action:^(REMenuItem *item){
        CGCViewController *controller = [[CGCViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [weakSelf pushViewController:controller animated:YES];}];

    REMenuItem *playItem = [[REMenuItem alloc] initWithCustomView:playMemory action:^(REMenuItem *item){
        CCRViewController *controller = [[CCRViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [weakSelf pushViewController:controller animated:YES];}];
    REMenuItem *playBubbleItem = [[REMenuItem alloc] initWithCustomView:playBubbles action:^(REMenuItem *item){
        BubbleGameViewController *controller = [[BubbleGameViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        [weakSelf pushViewController:controller animated:YES];}];


    _menu = [[REMenu alloc] initWithItems:@[recordItem, exportItem, reviewItem, playItem, playBubbleItem]];
    [_menu setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [_menu setSeparatorColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [_menu setSeparatorHeight:0];
     
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    __typeof (&*self) __weak weakSelf = self;

    if (buttonIndex == 1){
        VocabExportViewController *viewController = [[VocabExportViewController alloc]init];
        viewController.dataDelegate = self.dataDelegate;
        
        [viewController setVocabListName:[[alertView textFieldAtIndex:0] text]];
        [weakSelf pushViewController:viewController animated:YES];
    }
}


- (void)toggleMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    [_menu showFromNavigationController:self];
}
@end
