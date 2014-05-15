//
//  MoreMenuView.m
//  HeartCard
//
//  Created by Iphone_2 on 10/09/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "MoreMenuView.h"
#import "MoreOptionDetails.h"
#import "TransactionHistoryView.h"
#import "CategoryView.h"
#import "PrivacyPolicyView.h"
#import "TermsOfServicesView.h"
#import "StoreLocatorView.h"
#import "FAQView.h"
#import "ContactUSView.h"
#import "AboutUsView.h"

@interface MoreMenuView ()
{
    GlobalMethod *Method;
    NSOperationQueue *OperationQueueForOption;
    CGRect initialFrame;
    NSMutableArray *OptionsArray;
}

@end

@implementation MoreMenuView

@synthesize ScreenViewCategory, optionsTable, Spinner, BackView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       self=(IsIphone5)?[super initWithNibName:@"MoreMenuViewBig" bundle:nil]:[super initWithNibName:@"MoreMenuView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self PrepareScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)PrepareScreen
{
    
    //[[self BackView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Scroll_bg.png"]]];
    [[self BackView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:(IsIphone5)?@"background_scroll.jpg":@"background_scroll4.jpg"]]];
    [self SetBackground:ScreenViewCategory];
    [self AddTopBarToScreenView:ScreenViewCategory withTitle:@"MORE"];
    [self AddButtonBarToScreenView:ScreenViewCategory];
    [[self Spinner] startAnimating];
    OptionsArray = [[NSMutableArray alloc] init];
    OperationQueueForOption=[[NSOperationQueue alloc] init];
    Method=[[GlobalMethod alloc] init];
     [[self optionsTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"2" withName:@"CATEGORIES"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"5" withName:@"TRANSACTIONS"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"1" withName:@"ABOUT US"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"4" withName:@"FAQ"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"7" withName:@"STORE LOCATOR"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"3" withName:@"CONTACT US"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"6" withName:@"PRIVACY POLICY"]];
    [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"8" withName:@"TERMS OF SERVICE"]];
    
    //[self AssignWork];
    [self gotOptions];
}


-(void)AssignWork
{
    @autoreleasepool
    {
        NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getOptions) object:nil];
        [OperationQueueForOption addOperation:Operation];
    }
}




#pragma mark Thread Segments

-(void) getOptions
{
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@getMoreOptions.php", API];
        NSLog(@"URL : %@", url);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if([getData length]>2)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"999998" withName:@"CATEGORIES"]];
            [OptionsArray addObject:[[GlobalMethod alloc] initWithId:@"999999" withName:@"TRANSACTION"]];
            
            for(NSDictionary *var in getArray)
            {
                [OptionsArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"id"] withName:[var objectForKey:@"name"] withDescription:[var objectForKey:@"description"]]];
            }
            
            [self performSelectorOnMainThread:@selector(gotOptions) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(HandleError) withObject:nil waitUntilDone:YES];
        }
        
    }
    @catch(NSException *excepiton)
    {
        //Play with your cute & beautiful exception.
        [self performSelectorOnMainThread:@selector(HandleError) withObject:nil waitUntilDone:YES];
    }
}



#pragma mark Main Thread Segments

-(void)HandleError
{
    UIAlertView *showError=[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"Something is not right. Please try again later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Retry", nil];
    [showError setTag:13];
    [showError show];
}


-(void) gotOptions
{
    [[self Spinner] stopAnimating];
    [[self optionsTable] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    initialFrame=[BackView frame];
    initialFrame.size.height+=[OptionsArray count]*50;
    [BackView setFrame:initialFrame];
}




#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [OptionsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.frame = CGRectMake(3, 0, 313, 46);
    
    Method=[OptionsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    [cell.textLabel setText:Method.Name];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setTextColor:UIColorFromRGB(0xe8661c)];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


#pragma mark - delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.optionsTable deselectRowAtIndexPath:indexPath animated:YES];
    
    Method=[OptionsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    cell=[tableView cellForRowAtIndexPath:indexPath];
        
    
    
    if([[Method Id] isEqualToString:@"5"])
    {
        TransactionHistoryView *TransactionHistoryViewNib=[[TransactionHistoryView alloc] init];
        [[self navigationController] pushViewController:TransactionHistoryViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"2"])
    {
        CategoryView *CategoryViewNib=[[CategoryView alloc] init];
        [[self navigationController] pushViewController:CategoryViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"1"])
    {
        AboutUsView *AboutUsViewNib=[[AboutUsView alloc] init];
        [AboutUsViewNib setHeaderTitleString:[Method Name]];
        [[self navigationController] pushViewController:AboutUsViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"3"])
    {
        ContactUSView *ContactUSViewNib=[[ContactUSView alloc] init];
        [ContactUSViewNib setHeaderTitleString:[Method Name]];
        [[self navigationController] pushViewController:ContactUSViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"4"])
    {
        FAQView *FAQViewNib=[[FAQView alloc] init];
        [FAQViewNib setHeaderTitleString:[Method Name]];
        [[self navigationController] pushViewController:FAQViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"7"])
    {
        StoreLocatorView *StoreLocatorViewNib=[[StoreLocatorView alloc] init];
        [StoreLocatorViewNib setHeaderTitleString:[Method Name]];
        [[self navigationController] pushViewController:StoreLocatorViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"6"])
    {
        PrivacyPolicyView *PrivacyPolicyViewNib=[[PrivacyPolicyView alloc] init];
        [PrivacyPolicyViewNib setHeaderTitleString:[Method Name]];
        [[self navigationController] pushViewController:PrivacyPolicyViewNib animated:YES];
    }
    else if([[Method Id] isEqualToString:@"8"])
    {
        TermsOfServicesView *TermsOfServicesViewNib=[[TermsOfServicesView alloc] init];
        [TermsOfServicesViewNib setHeaderTitleString:[Method Name]];
        [[self navigationController] pushViewController:TermsOfServicesViewNib animated:YES];
    }
    else
    {
        MoreOptionDetails *MoreOptionDetailsNib=[[MoreOptionDetails alloc] init];
        [MoreOptionDetailsNib setParamMethod:Method];
        [[self navigationController] pushViewController:MoreOptionDetailsNib animated:YES];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(initialFrame.size.height>0)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect TempRect=initialFrame;
        TempRect.origin.y-=offset.y;
        [BackView setFrame:TempRect];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        if([alertView tag]==13)
        {
            [self AssignWork];
        }
    }
}


-(void)goBack
{
    [self PerformGoBackTo:@"CategoryView"];
}


@end
