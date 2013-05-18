//
//  CharacterBreakdownViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/15/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "CharacterBreakdownViewController.h"

@implementation CharacterBreakdownViewController{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    
    CGSize expectedLabelSize = [_text sizeWithFont:_breakdown.font constrainedToSize:maximumLabelSize lineBreakMode:_breakdown.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = _breakdown.frame;
    newFrame.size.height = expectedLabelSize.height;
    _breakdown.frame = newFrame;
    //_scrollView.frame = newFrame;
    
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
