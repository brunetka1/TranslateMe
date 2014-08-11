//
//  MEListTableViewController.m
//  TranslateMe
//
//  Created by Katushka on 8/5/14.
//  Copyright (c) 2014 Katushka. All rights reserved.
//

#import "MEListTableViewController.h"
#import "METableViewCell.h"
#import "MEWord.h"
#import "MEDataManager.h"

@interface MEListTableViewController ()

@end

@implementation MEListTableViewController

#pragma mark - ManagedObjectContext

- (NSManagedObjectContext*) managedObjectContext  {
    
    return [[MEDataManager sharedManager] managedObjectContext];
}

#pragma mark - Edit

- (void)actionEdit:(UIBarButtonItem*)sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item
                                                                               target:self
                                                                               action:@selector(actionEdit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
}


#pragma mark - Actions

- (void) actionAllWords:(UIBarButtonItem*) sender {
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"MEWord"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* error = nil;
    
    self.words = [[self.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if (error) {
        
        NSLog(@"ERROR! %@",[error localizedDescription]);
        
    }
    
    [self.tableView reloadData];
    
}


- (void) getWordsToday {
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"MEWord"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];

    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:components];
    [components setMonth:0];
    [components setDay:1];
    [components setYear:0];
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(modifiedDate >= %@) AND (modifiedDate < %@) || (modifiedDate = nil)", startDate, endDate];
    
    [request setPredicate:predicate];
    
    NSError* error = nil;
    
    self.words = [[self.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    if (error) {
        
        NSLog(@"ERROR! %@",[error localizedDescription]);
        
    }


    [self.tableView reloadData];
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self getWordsToday];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                               target:self
                                                                               action:@selector(actionEdit:)];
    
    UIBarButtonItem* allWordsButton = [[UIBarButtonItem alloc]initWithTitle:@"All words"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(actionAllWords:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: editButton, allWordsButton, nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}

#pragma mark - UITableViewDataSource


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MEWord* word = [self.words objectAtIndex:indexPath.row];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.words];
        [tempArray removeObject:word];
        self.words = tempArray;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
        
        
        [self.managedObjectContext deleteObject:word];
    
        [self.managedObjectContext save:nil];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* identifier = @"cell";
    
    METableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    MEWord* word = [self.words objectAtIndex:indexPath.row];

  
    [cell.wordLabel setText:[NSString stringWithFormat:@"%@",word.languageFrom]];
    [cell.translateLabel setText:[NSString stringWithFormat:@"%@",word.languageTo]];
    
    return cell;
}

@end
