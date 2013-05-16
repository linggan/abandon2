//
//  FlatButton.m
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "FlatButton.h"
#include <QuartzCore/QuartzCore.h>

@implementation FlatButton

- (id)initWithFrame:(CGRect)frame
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self setFrame:frame];
    }
    return self;
}

+(FlatButton *)FlatButtonWithFrame:(CGRect)frame WithText:(NSString *)text andBackgroundColor:(UIColor *)color{
    FlatButton *newBtn = [[FlatButton alloc]initWithFrame:frame];
    
    [[newBtn titleLabel] setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:24]];
    [newBtn setTitle:text forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setBackgroundColor:color];
    [newBtn setShowsTouchWhenHighlighted:YES];
    
    return newBtn;
}



@end
