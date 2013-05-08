//
//  CGCViewController.m
//  DrawingPortion
//
//  Created by Carl G Cota-Robles on 5/5/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import "CGCViewController.h"

@interface CGCViewController ()

@end

@implementation CGCViewController

@synthesize wordList;
@synthesize atLastWord;

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
    self.definition.text = [wordList[self.wordListTracker] valueForKey:@"english"];
    self.oldDrawing.image = nil;
    self.correctOldDrawing.text = @"";
    atLastWord  = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getWords:(id)ViewController{
    wordList = [[self dataDelegate] getAllWords];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (atLastWord) {
        return;
    }
    
    self.mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    self.currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
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
        return;
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
    else if (self.wordListTracker == self.wordList.count-1)
    {
        self.oldDrawing.image = self.arrayOfDrawings[self.wordListTracker-1];
        self.correctOldDrawing.text = [self.wordList[self.wordListTracker-1] valueForKey:@"chinese"];
        self.imageView.image = nil;
        self.wordListTracker++;
        atLastWord = YES;
    }
    else if (self.wordListTracker < self.wordList.count-1)
    {
        NSLog(@"Hit!");
        UIImage *mostRecentImage = self.imageView.image;
        if (mostRecentImage == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Don't be lazy!" message:@"Draw Something!" delegate:nil cancelButtonTitle:@"Fine" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        self.imageView.image = nil;
        [self.arrayOfDrawings addObject:mostRecentImage];
        self.wordListTracker ++;
        self.definition.text = [wordList[self.wordListTracker] valueForKey:@"english"];
        self.oldDrawing.image = self.arrayOfDrawings[self.wordListTracker-1];
        self.correctOldDrawing.text = [self.wordList[self.wordListTracker-1] valueForKey:@"chinese"];
    }
}
@end

