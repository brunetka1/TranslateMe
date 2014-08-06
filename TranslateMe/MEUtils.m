//
//  MEUtils.m
//  TranslateMe
//
//  Created by Katushka on 8/5/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import "MEUtils.h"

NSString* dateStringFromDate (NSDate* date) {
    
    static NSDateFormatter* formatter = nil;
    
    if (!formatter) {
        
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"-- dd : MM : yy --"];
        
    }
    return [formatter stringFromDate:date];
    
}

