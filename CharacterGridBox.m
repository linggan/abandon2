//
//  CharacterGridBox.m
//  abandonDraft
//
//  Created by Gwendolyn Weston on 4/26/13.
//  Copyright (c) 2013 Coefficient Zero. All rights reserved.
//

#import "CharacterGridBox.h"
#include <QuartzCore/QuartzCore.h>

@implementation CharacterGridBox

- (id)initWithFrame:(CGRect)frame
       AndCharacter: (NSString *)character
{
    self = [super initWithFrame:frame];
    if (self) {
        _characterBoxText = [[UILabel alloc]initWithFrame:frame];
        [_characterBoxText setTextAlignment:NSTextAlignmentCenter];
        [_characterBoxText setText:character];
        self.character = character;
        [_characterBoxText setTextColor:[UIColor whiteColor]];
        [_characterBoxText setBackgroundColor:[UIColor colorWithRed:(float)102/255 green:(float)102/255 blue:(float)102/255 alpha:1]];
        [[_characterBoxText layer] setMasksToBounds:YES];
        [[_characterBoxText layer] setBorderWidth:1.0f];
        [[_characterBoxText layer] setBorderColor:[UIColor grayColor].CGColor];

        [self addSubview:_characterBoxText];
        [self setSelected:false];
        
    }
    
    return self;
}

-(NSString*)getWord
{
    return self.character;
}



@end
