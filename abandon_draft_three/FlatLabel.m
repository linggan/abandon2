//
//  FlatLabel.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/5/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "FlatLabel.h"

@implementation FlatLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
    }
    return self;
}

+(FlatLabel *)FlatLabelWithFrame:(CGRect)frame WithText:(NSString *)text andBackgroundColor:(UIColor *)color{
    FlatLabel *newLabel = [[FlatLabel alloc]initWithFrame:frame];
    
    [newLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:24]];
    [newLabel setText:text];
    [newLabel setTextColor:[UIColor colorWithRed:(float)77/255 green:(float)77/255 blue:(float)77/255 alpha:0.59]];
    [newLabel setBackgroundColor:color];
    
    return newLabel;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 8, 0, 8};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
