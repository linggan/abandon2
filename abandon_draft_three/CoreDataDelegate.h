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

//setting/changing entries from coredata
-(NSArray *)addToDatabaseDictEntryOfWord: (NSString *)word;
-(void)deleteWordFromQueue:(NSString*)Word;
-(void)storeAAC:(NSString *)URL ForWord:(NSString *)Word InLanguage:(NSString *)Language;
@end
