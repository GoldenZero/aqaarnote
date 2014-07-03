//
//  SearchDetailsVC.m
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "SearchDetailsVC.h"
#import "SearchDetailCell.h"
@interface SearchDetailsVC ()
{
    NSMutableArray * searchsArray;
    NSMutableArray * dataArray;
   // MRProgressOverlayView *progressView;
    UITextField *txt;
}
@end

@implementation SearchDetailsVC

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
    [self loadDataWith:@"Airport"];

    // Do any additional setup after loading the view.
}

#pragma mark - UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchsArray count];
        
    } else {
        return [dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *SearchCellIdentifier = @"SearchCell";
    
    SearchDetailCell *cell;
    NSDictionary *term;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
        term =[searchsArray objectAtIndex:indexPath.row];
        
    } else {
        term =[dataArray objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    if (cell == nil) {
        cell = [[SearchDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchDetailCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    

    cell.title.text=term[@"name"];

    [cell.icon setImageWithURL:[NSURL URLWithString:term[@"icon"]]
                   placeholderImage:[UIImage imageNamed:@"airplane"]];
    
    [cell.title setFont:[UIFont lightGeSSOfSize:14]];

 //   cell.icon.image=[UIImage imageNamed:@"airplane"];
    
   	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *term;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        term =[searchsArray objectAtIndex:indexPath.row];
        
    } else {
        term =[dataArray objectAtIndex:indexPath.row];
    }
    [self.delegate chosenPlace:term[@"name"]];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier:@"backToAddWish" sender:self];
    
}

#pragma mark - Buttons Actions
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    [[NetworkEngine getInstance] searchForLocation:searchText latitude:@"" longitude:@"" token:@"" completionBlock:^(NSObject  *o,NSString* message)
     {
         searchsArray = [NSMutableArray new];
         NSArray* tempO = (NSArray*)o;
         for (NSDictionary* t in tempO) {
             [searchsArray addObject:t];
         }
         [self.searchsTableView setNeedsDisplay];
         [self.searchDisplayController.searchResultsTableView setNeedsDisplay];
         [self.searchDisplayController.searchResultsTableView reloadData];
         


     }failureBlock:^(NSError* error)
     {
         
         if (error.code == 400) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:NSLocalizedString(@"login_error_credential", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
         }else
         {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
         }
         
     }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // TODO : call Search engine
    return YES;
}

- (void) loadDataWith:(NSString*)word{
    [[NetworkEngine getInstance] searchForLocation:word latitude:@"" longitude:@"" token:@"" completionBlock:^(NSObject  *o,NSString* message)
     {
         dataArray = [NSMutableArray new];
         NSArray* tempO = (NSArray*)o;
         for (NSDictionary* t in tempO) {
             [dataArray addObject:t];
         }
         [self.searchsTableView setNeedsDisplay];
         [self.searchsTableView reloadData];
         
         
     }failureBlock:^(NSError* error)
     {
         
         if (error.code == 400) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:NSLocalizedString(@"login_error_credential", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
         }else
         {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
         }
         
     }];
}
@end