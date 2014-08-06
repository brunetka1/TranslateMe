//
//  MEHintViewController.m
//  TranslateMe
//
//  Created by Katushka on 8/6/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import "MEHintViewController.h"

@interface MEHintViewController ()



@end

@implementation MEHintViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"penguin" ofType:@"png"];
    
    imageView.image = [UIImage imageWithContentsOfFile:filePath];
    
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
