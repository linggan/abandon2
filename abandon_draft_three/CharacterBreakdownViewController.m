//
//  CharacterBreakdownViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/15/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "CharacterBreakdownViewController.h"

@interface CharacterBreakdownViewController ()

@end

@implementation CharacterBreakdownViewController

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
    [_breakdown setText:_text];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectDone:(id)sender {
    [self.modalDelegate didDismissPresentedViewController];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self didSelectDone:self];
    }
}


@end
