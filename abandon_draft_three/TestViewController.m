//
//  TestViewController.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/29/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "TestViewController.h"
#import "SmoothLineView.m"
#import "AnswerViewController.h"

@implementation TestViewController{
    int currentIndex;
    SmoothLineView *canvas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init audio player and sesson
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionsError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionsError];
    [session setActive:YES error:nil];

    UIActionSheet *testingModeSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Testing Mode" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Listening", @"Translation", @"Recognition", nil];
    [testingModeSheet showInView:self.view];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft: )];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeft setDelegate:self];
    [[self view]addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight: )];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight setDelegate:self];
    [[self view]addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *answerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAnswerTap:)];
    answerTap.numberOfTapsRequired = 2;
    answerTap.delegate = self;
    [[self view] addGestureRecognizer:answerTap];


    [_translationLabel setHidden:TRUE];
    [_recognitionLabel setHidden:TRUE];
    
    currentIndex = 0;
    [self permuteWords];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLabels{
    _recognitionLabel.text = [[_wordList objectAtIndex:currentIndex] valueForKey:@"chinese"];
    _translationLabel.text = [[_wordList objectAtIndex:currentIndex] valueForKey:@"english"];
}

-(void)permuteWords{
    NSMutableArray *permutation = [[self wordList] mutableCopy];
    for (int i = 0; i <[permutation count]; i++){
        int random = arc4random()%[permutation count];
        id temp = permutation[i];
        [permutation setObject:permutation[random] atIndexedSubscript:i];
        [permutation setObject:temp atIndexedSubscript:random];
    }
    _wordList = permutation;

}

-(void)prepareTestingMode{
    if ([[self testingMode] isEqualToString:@"Listening"]){
        canvas = [[SmoothLineView alloc] initWithFrame:self.view.frame];
        [[self view] addSubview:canvas];
        
        UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayTap:)];
        playTap.numberOfTapsRequired = 1;
        playTap.delegate = self;
        
        Word *word = [_wordList objectAtIndex:currentIndex];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[word valueForKey:@"chineseRecording"]] error:nil];
        [_player setDelegate:self];
        [_player play];

        [[self view] addGestureRecognizer:playTap];

        
    }
    
    if ([[self testingMode] isEqualToString:@"Translation"]){
        canvas = [[SmoothLineView alloc] initWithFrame:self.view.frame];
        [[self view] addSubview:canvas];
        [_translationLabel setHidden:FALSE];
        [[self view] bringSubviewToFront:_translationLabel];

        
    }
    
    if ([[self testingMode] isEqualToString:@"Recognition"]){
        [[self view] sendSubviewToBack:_translationLabel];
        [_recognitionLabel setHidden:FALSE];
        
    }
    [self setLabels];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self setTestingMode:@"Listening"];
            break;
        case 1:
            [self setTestingMode:@"Translation"];
            break;
        case 2:
            [self setTestingMode:@"Recognition"];
            break;
        case 3:
            [[self navigationController] popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
    [self prepareTestingMode];

}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if (currentIndex < [_wordList count]-1){
            currentIndex++;
            [self setLabels];
            
            Word *word = [_wordList objectAtIndex:currentIndex];
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[word valueForKey:@"chineseRecording"]] error:nil];
            [_player setDelegate:self];
            [_player play];

            canvas = [[SmoothLineView alloc] initWithFrame:self.view.frame];
            [[self view] addSubview:canvas];
            if ([_testingMode isEqualToString:@"Translation"]) [[self view] bringSubviewToFront:_translationLabel];

        }
    }
}


- (void)handleSwipeRight:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if (currentIndex < [_wordList count]-1){
            canvas = [[SmoothLineView alloc] initWithFrame:self.view.frame];
            [[self view] addSubview:canvas];
            if ([_testingMode isEqualToString:@"Translation"]) [[self view] bringSubviewToFront:_translationLabel];
            
        }
    }
}

- (void)handlePlayTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [_player play];
    }
}



- (void)handleAnswerTap:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        AnswerViewController *controller = [[AnswerViewController alloc]init];
        controller.word = [_wordList objectAtIndex:currentIndex];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        controller.modalDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
