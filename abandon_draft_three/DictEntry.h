//
//  DictEntry.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/14/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DictEntry : NSManagedObject

@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSString * pinyin;
@property (nonatomic, retain) NSString * simplified;
@property (nonatomic, retain) NSString * traditional;
@property (nonatomic, retain) NSString * mnemonic;

@end
