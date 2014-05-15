//
//  TransactionHistoryView.m
//  HeartCard
//
//  Created by Iphone_2 on 25/09/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "TransactionHistoryView.h"

@interface TransactionHistoryView ()
{
    GlobalMethod *Method;
    NSOperationQueue *OperationQueue;
    NSMutableArray *TransactionArray;
}
@end

@implementation TransactionHistoryView

@synthesize ScreenViewTranHistroy, TVTranHistroy, SpinnerTranHistroy, LblCardCredit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"TransactionHistoryViewBig" bundle:nil]:[super initWithNibName:@"TransactionHistoryView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self PrepareScreens];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)PrepareScreens
{
    [self SetBackground:ScreenViewTranHistroy];
    [self AddButtonBarToScreenView:ScreenViewTranHistroy];
    [self AddTopBarToScreenView:ScreenViewTranHistroy withTitle:@"HISTORY"];
    
    OperationQueue=[[NSOperationQueue alloc] init];
    TransactionArray=[[NSMutableArray alloc] init];
    
    
    NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
    [LblCardCredit setText:[NSString stringWithFormat:@"%d", (int)[UserDefaults integerForKey:SESSION_USERCREDITS]]];
    
    [self AssignWork];
}

-(void)AssignWork
{
    @autoreleasepool
    {
        NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getTransactionHistory) object:nil];
        [OperationQueue addOperation:Operation];
    }
}

#pragma mark Thread Segments

-(void)getTransactionHistory
{
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@userCredits_V2.php?objectType=history&deviceId=%@", API, DeviceId];
        NSLog(@"URL : %@", url);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if([getData length]>2)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            for(NSDictionary *var in getArray)
            {
                [TransactionArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"id"] withCredit:[var objectForKey:@"credit"] withCreditDate:[var objectForKey:@"credit_date"] withPackageType:[var objectForKey:@"package_type"]]];
            }
            
            [self performSelectorOnMainThread:@selector(gotTransactionHistory) withObject:nil waitUntilDone:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
               
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No Record Found" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert setTag:12];
                [alert show];
                
            });
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


-(void) gotTransactionHistory
{
    [[self SpinnerTranHistroy] stopAnimating];
    [[self TVTranHistroy] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    return [TransactionArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] objectAtIndex:1];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Method=[TransactionArray objectAtIndex:[indexPath row]];
    
    UILabel *LblDate=(UILabel *)[cell viewWithTag:1];
    [LblDate setText:[Method CreditDate]];
    
    UILabel *LblPackage=(UILabel *)[cell viewWithTag:2];
    [LblPackage setText:[Method PackageType]];
    
    UILabel *LblCredit=(UILabel *)[cell viewWithTag:3];
    [LblCredit setText:[Method Credit]];
    
    return cell;
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
    else if(buttonIndex==0)
    {        
        if([alertView tag]==13 || [alertView tag]==12)
        {
            [self goBack];
        }
    }
}


-(void)goBack
{
    [self PerformGoBackTo:@"MoreMenuView"];
}

@end
