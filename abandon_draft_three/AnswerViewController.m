//
//  AnswerViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/29/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_answer setText:[_word valueForKey:@"chinese"]];
    [_pinyin setText: [_word valueForKey:@"pinyin"]];
    [_english setText:[_word valueForKey:@"english"]];
    
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
