//
//  CharacterInfoViewController.m
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/2/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "CharacterInfoViewController.h"

@interface CharacterInfoViewController ()

@end

@implementation CharacterInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_chinese setText:[_word objectAtIndex:0]];
    [_pinyin setText:[_word objectAtIndex:1]];
    [_english setText:[_word objectAtIndex:2]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didSelectDone:(id)sender {
    [self.modalDelegate didDismissPresentedViewController];
}


- (IBAction)dismissScreen:(id)sender {
    [self didSelectDone:self];

}
@end
