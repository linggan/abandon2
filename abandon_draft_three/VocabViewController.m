//
//  VocabViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/28/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "VocabViewController.h"
#import "VocabExportViewController.h"
#import "VocabBreakdownViewController.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"

@implementation VocabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    _vocabLists = [[self dataDelegate] getAllVocabLists];
    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view addSubview:scroller];
    
    MGTableBoxStyled *topSection = MGTableBoxStyled.box;
    [scroller.boxes addObject:topSection];

    MGLineStyled *topRow = [MGLineStyled lineWithLeft:@"Make new vocab list" right:@"" size:(CGSize){304, 40}];
    [topRow setBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)101/255 blue:(float)136/255 alpha:1]];
    [topRow setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:18]];
    topRow.onTap = ^{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Vocab List" message:@"Give it a nice name, yeah?" delegate:self cancelButtonTitle:@"Nah" otherButtonTitles:@"Okay", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeAlphabet;
        [alert show];
        
    };
    
    
    [topSection.topLines addObject:topRow];
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    
    for (id list in _vocabLists){
        
        MGLineStyled *row = [MGLineStyled lineWithLeft:[list valueForKey:@"name"]
                                                  right:@"" size:(CGSize){304, 40}];
        [row setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:18]];
        row.onTap = ^{
            VocabBreakdownViewController *controller = [[VocabBreakdownViewController alloc] init];
            [controller setVocabList:list];
            
            [[self navigationController] pushViewController:controller animated:YES];


        };
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

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        VocabExportViewController *controller = [[VocabExportViewController alloc] init];
        controller.dataDelegate = self.dataDelegate;
        controller.modalDelegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [controller setVocabListName:[[alertView textFieldAtIndex:0] text]];

        [[self navigationController] pushViewController:controller animated:YES];
        //[self presentViewController:controller animated:YES completion:NULL];
    }
}

@end
