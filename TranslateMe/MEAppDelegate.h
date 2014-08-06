//
//  MEAppDelegate.h
//  TranslateMe
//
//  Created by Katushka on 8/5/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
