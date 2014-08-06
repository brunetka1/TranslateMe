//
//  MEWord.h
//  TranslateMe
//
//  Created by Katushka on 8/6/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MEWord : NSManagedObject

@property (nonatomic, retain) NSString * languageFrom;
@property (nonatomic, retain) NSString * languageTo;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSDate * createdDate;

@end
