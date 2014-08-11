//
//  MEDataManager.h
//  TranslateMe
//
//  Created by Katushka on 8/6/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEDataManager : NSObject

+ (MEDataManager*) sharedManager;

- (NSManagedObjectContext *)managedObjectContext;
@end
