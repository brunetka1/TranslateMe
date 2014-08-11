//
//  MERandomWordsViewController.m
//  TranslateMe
//
//  Created by Katushka on 8/6/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import "MERandomWordsViewController.h"
#import "MEWord.h"
#import "MEDataManager.h"


@interface MERandomWordsViewController () <UITextFieldDelegate>

{
    NSInteger countAlert;
}

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel* wordLabel;
@property (weak, nonatomic) IBOutlet UITextField* translateField;
@property (strong, nonatomic) NSMutableArray* words;
@property (strong, nonatomic) MEWord* word;



- (IBAction)actionEnter:(id)sender;

@end

@implementation MERandomWordsViewController

#pragma mark - ManagedObjectContext

- (NSManagedObjectContext*) managedObjectContext  {
    
   return [[MEDataManager sharedManager] managedObjectContext];
}


# pragma mark - Actions

- (void) getOtherWord {
    
    if (!self.words.count && self.words)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.word = [self getRandomWord];
    
    [self.wordLabel setText:[NSString stringWithFormat:@"%@",self.word.languageFrom]];
    self.translateField.text = @"";
    
    
}

- (void) allWords {
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"MEWord"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    
    [request setEntity:description];
    
    NSError* error = nil;
    
    
    
    self.words = [[self.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    NSLog(@"%@",self.words);
    
    if (error) {
        
        NSLog(@"ERROR! %@",[error localizedDescription]);
        
    }
    
    
}

- (MEWord*) getRandomWord {
    
    MEWord* word = [self.words objectAtIndex:arc4random_uniform([self.words count])];
    [self.words removeObject:word];
    
    return word;
    
}

- (IBAction)actionEnter:(UIButton*)sender {
    
    
    NSString *translateText = [self.translateField.text lowercaseString];
    MEWord* word = self.word;
    NSString *wordText = [word.languageTo lowercaseString];
    
    
    
    if  ([self.translateField.text isEqualToString:@""]) {
        
        
        [[[UIAlertView alloc] initWithTitle:@"ERROR!"
                                    message:@"Field empty!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles: nil]show];
        
    }
    else {
        
        
        
        if ((![translateText isEqualToString:wordText]) && (countAlert<3)){
            
            countAlert += 1;
            
            [[[UIAlertView alloc] initWithTitle:@"Not the correct translation!"
                                        message:@"Try again"
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles: nil]show];
            
        } else if ((![translateText isEqualToString:wordText]) && (countAlert=3)) {
            
            countAlert = 0;
            [[[UIAlertView alloc] initWithTitle:@"Hint!"
                                        message:[NSString stringWithFormat:@"%@ - %@",word.languageFrom,wordText]
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles: nil]show];
            
            
           [self getOtherWord];
            
            return;
            
        } else if ([translateText isEqualToString:wordText]) {
            
            countAlert = 0;
            
            [self getOtherWord];
            
            return;
            
        }
    }
}


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
    [self allWords];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.wordLabel];
    
    [self getOtherWord];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.translateField]) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
