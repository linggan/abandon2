//
//  CGCViewController.h
//  DrawingPortion
//
//  Created by Carl G Cota-Robles on 5/5/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataDelegate.h"

@interface CGCViewController : UIViewController

@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;
@property(nonatomic, strong) NSArray *wordList;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) Boolean mouseSwiped;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)clearContext:(id)sender;
- (IBAction)storeImage:(id)sender;

@property(nonatomic) NSInteger wordListTracker;
@property(nonatomic, strong) NSMutableArray *arrayOfDrawings;
@property (weak, nonatomic) IBOutlet UILabel *definition;
@property (weak, nonatomic) IBOutlet UILabel *correctOldDrawing;
@property (weak, nonatomic) IBOutlet UIImageView *oldDrawing;

@property (nonatomic) Boolean atLastWord;


@end
