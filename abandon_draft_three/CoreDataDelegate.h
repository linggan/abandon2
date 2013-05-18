//
//  coreDataDelegate.h
//  abandonDraft
//
//  Created by Gwendolyn Weston on 3/29/13.
//  Copyright (c) 2013 Coefficient Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoreDataDelegate <NSObject>
//getting entries for coredata
-(BOOL)WordIsAlreadyInDatabase:(NSString *)word;
-(NSArray *)getAllWords;
-(NSArray *)getAllUnrecordedWordsinQueue;
-(NSString *)getComponentBreakdownOfCharacter:(NSString *)character;
-(NSArray *)lookUpCharacter:(NSString *)character;

//setting/changing entries from coredata
-(NSArray *)addToDatabaseDictEntryOfWord: (NSString *)word;
-(void)addMnemonic:(NSString*)mnemonic ToWord:(NSString*)word;
-(void)deleteWordFromQueue:(NSString*)Word;
-(void)deleteWordFromBank:(NSString*)word;
-(void)storeAAC:(NSString *)URL ForWord:(NSString *)Word InLanguage:(NSString *)Language;
@end
