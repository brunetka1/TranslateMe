//
//  MEWordViewController.m
//  TranslateMe
//
//  Created by Katushka on 8/5/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import "MEWordViewController.h"
#import "MEWord.h"
#import "MEDataManager.h"

@interface MEWordViewController () <UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITextField *wordField;
@property (weak,nonatomic) IBOutlet UITextField *translateField;

- (IBAction)actionSave:(id)sender;

@end

@implementation MEWordViewController

#pragma mark - Actions

- (void) deleteAllObjects {
    
    [self allWords];
    NSArray *resultArray = self.words;
    
    for (id object in resultArray) {
        
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
    
}

- (IBAction)actionSave:(id)sender {

    
    if (([self.wordField.text isEqualToString:@""]) || ([self.translateField.text isEqualToString:@""])) {
        
        
        [[[UIAlertView alloc] initWithTitle:@"ERROR!"
                                    message:@"Field empty!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles: nil]show];
        
    }
    else {
        
        [self addWord];
        
        
        self.wordField.text = @"";
        self.translateField.text = @"";
        
        [self performSegueWithIdentifier:@"save" sender:sender];
        
    }
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
- (MEWord*) addWord {
    
   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSCalendarUnitYear | NSMonthCalendarUnit | NSCalendarUnitDay ) fromDate:[NSDate date]];
    
    NSDate *date = [calendar dateFromComponents:components];
    
    NSString* stringWord = [self.wordField.text lowercaseString];
    
    [self allWords];
    NSLog(@"%@",self.words);
        
        for (id object in self.words) {
            
            MEWord* word = (MEWord*) object;
            
            if ([stringWord isEqualToString:[word.languageFrom lowercaseString]]) {
                
                word.modifiedDate = date;
                
                return word;
            }
        }
    
    MEWord* someWord = [NSEntityDescription insertNewObjectForEntityForName:@"MEWord"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    someWord.languageFrom = self.wordField.text;
    someWord.languageTo = self.translateField.text;
    
    
    someWord.modifiedDate = date;
    someWord.createdDate = date;
    
    NSError* error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"%@",[error localizedDescription]);
    }
    
    return someWord;
    
}

#pragma mark - ManagedObjectContext

- (NSManagedObjectContext*) managedObjectContext  {
    
    return [[MEDataManager sharedManager] managedObjectContext];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   //[self deleteAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.wordField]) {
        
        [self.translateField becomeFirstResponder];
        
      
        
    } else if ([textField isEqual:self.translateField]) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}



@end
