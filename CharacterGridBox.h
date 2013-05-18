//
//  CharacterGridBox.h
//  abandonDraft
//
//  Created by Gwendolyn Weston on 4/26/13.
//  Copyright (c) 2013 Coefficient Zero. All rights reserved.
//

#import "MGBox.h"

@interface CharacterGridBox : MGBox

@property (nonatomic, retain) UILabel *characterBoxText;
@property BOOL selected;

- (id)initWithFrame:(CGRect)frame AndCharacter: (NSString *)character;

@property (nonatomic, strong) NSString *character;

-(NSString*)getCharacter;

-(void)removeBox;

@end
