//
//  CGCViewController.m
//  DrawingPortion
//
//  Created by Carl G Cota-Robles on 5/5/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import "CGCViewController.h"

@interface CGCViewController () <UIAlertViewDelegate> //The View Controller for the Drawing Practice Game

@end

@implementation CGCViewController

@synthesize wordList;
@synthesize atLastWord;

#define INAPP 5

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.arrayOfDrawings = [NSMutableArray array];
    self.wordListTracker = 0;
    
    [self getWords:self];
    NSLog(@"Before Alert View");
    if (wordList.count <= 0) //If there's no words in the word bank, it complains to the user in an Alert View
    {
        NSLog(@"Alert View");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hmmm" message:@"Your word bank is empty" delegate:self cancelButtonTitle:@"Add words!" otherButtonTitles:nil];
        alertView.tag = INAPP;
        [alertView show];
        return;
    }
    
    self.definition.text = [wordList[self.wordListTracker] valueForKey:@"english"];
    self.oldDrawing.image = nil;
    self.correctOldDrawing.text = @"";
    atLastWord  = NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == INAPP)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getWords:(id)ViewController{
    NSMutableArray *permutation = [[[self dataDelegate] getAllWords] mutableCopy];
    for (int i = 0; i <[permutation count]; i++){
        int random = arc4random()%[permutation count];
        id temp = permutation[i];
        [permutation setObject:permutation[random] atIndexedSubscript:i];
        [permutation setObject:temp atIndexedSubscript:random];
    }
    wordList = permutation;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (atLastWord) { //If we're at the last word, doesn't let th user draw something, only displays the previous drawing.
        return;
    }
    
    self.mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    self.currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
    self.lastPoint = self.currentPoint;
    CGContextStrokePath(context);
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.imageView setAlpha:1.0];
    UIGraphicsEndImageContext();
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (atLastWord) {
        return; //If we're at the last word, it doesn't let the user draw anything, only displays
        //the previous drawing.
    }
    
    if (!self.mouseSwiped)
    {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.imageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 4.0);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(context);
        CGContextFlush(context);
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.imageView setAlpha:1.0];
        UIGraphicsEndImageContext();
    }
    self.mouseSwiped = NO;
}



- (IBAction)clearContext:(id)sender {
    
    self.imageView.image = nil;
}

- (IBAction)storeImage:(id)sender {
        
    if (self.wordListTracker > self.wordList.count-1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else if (self.wordListTracker <= self.wordList.count-1)
    {
        UIImage *mostRecentImage = self.imageView.image;
        self.imageView.image = nil;
        [self.arrayOfDrawings addObject:mostRecentImage];
        self.wordListTracker ++;
        
        if (self.wordListTracker < self.wordList.count) {
            self.definition.text = [wordList[self.wordListTracker] valueForKey:@"english"];
        }
        else {
            //Let's the user know we're done drawing.
            self.definition.text = @"";
            self.infoDescription.text = @"Finished all the words! Wow.";
            atLastWord = YES;

        }
        
        self.oldDrawing.image = self.arrayOfDrawings[self.wordListTracker-1];
        self.correctOldDrawing.text = [self.wordList[self.wordListTracker-1] valueForKey:@"chinese"];
    }
}
@end

