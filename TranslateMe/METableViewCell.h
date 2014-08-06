//
//  METableViewCell.h
//  TranslateMe
//
//  Created by Katushka on 8/5/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface METableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* wordLabel;
@property (weak, nonatomic) IBOutlet UILabel* translateLabel;

@end
