//
//  CoreDataTestHelper.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/5/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataTestHelper : NSObject
-(NSArray *)printDataForEntitiesOfType: (NSString *)entityName;
-(void)deleteALLtheData;
@end
