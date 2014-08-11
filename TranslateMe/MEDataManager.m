//
//  MEDataManager.m
//  TranslateMe
//
//  Created by Katushka on 8/6/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import "MEDataManager.h"
#import "MEWord.h"

@implementation MEDataManager

+ (MEDataManager*) sharedManager {
    
    static MEDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MEDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - ManagedObjectContext


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
