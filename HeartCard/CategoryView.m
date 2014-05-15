//
//  CategoryView.m
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "CategoryView.h"
#import "cardsView.h"

@interface CategoryView ()
{
    GlobalMethod *Method;
    NSOperationQueue *OperationQueueForCategory;
    CGRect initialFrame;
    NSMutableArray *TableViewArray;
}

@end

@implementation CategoryView

@synthesize ScreenViewCategory, categoryTable, Spinner, CategoryArray, BackView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    { 
        self=(IsIphone5)?[super initWithNibName:@"CategoryViewBig" bundle:nil]:[super initWithNibName:@"CategoryView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self PrepareScreen];
    
    NSLog(@"i am in CategoryView section");
    
//    for(NSString* family in [UIFont familyNames]) {
//        NSLog(@"%@", family);
//        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//            NSLog(@"  %@", name);
//        }
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PrepareScreen
{
    //[[self BackView] setBackgroundColor:[UIColor clearColor]];
    [[self BackView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:(IsIphone5)?@"background_scroll.jpg":@"background_scroll4.jpg"]]];
    
    //[self SetBackground:ScreenViewCategory];
    [self AddTopBarWithOutButtonToScreenView:ScreenViewCategory withTitle:@"CATEGORIES"];
    [self AddButtonBarToScreenView:ScreenViewCategory];
    [[self Spinner] startAnimating];
    CategoryArray = [[NSMutableArray alloc] init];
    OperationQueueForCategory=[[NSOperationQueue alloc] init];
    Method=[[GlobalMethod alloc] init];
    
    [[self categoryTable] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self AssignWork];
}


-(void)AssignWork
{
    @autoreleasepool
    {
        NSInvocationOperation *OperationCredit=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getCredit) object:nil];
        [OperationQueueForCategory addOperation:OperationCredit];
        
        NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(FetchCategories) object:nil];
        [OperationQueueForCategory addOperation:Operation];
    }
}

#pragma mark Thread Segments

-(void) FetchCategories
{
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@categories.php", API];
        NSLog(@"URL : %@", url);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
        if([getData length]>2)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            for(NSDictionary *var in getArray)
            {
                [CategoryArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"id"] withName:[var objectForKey:@"name"]]];
            }
            
            [self performSelectorOnMainThread:@selector(gotCategories) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(HandleError) withObject:nil waitUntilDone:YES];
        }
        
    }
    @catch(NSException *juju)
    {
        //Play with your cute & beautiful exception.
        NSLog(@"Reporting juju from FetchCategories: %@",juju);
        [self performSelectorOnMainThread:@selector(HandleError) withObject:nil waitUntilDone:YES];
    }
}
-(void)CancelRateview {
    NSLog(@"---------i am in cancel");
}
-(void)OkRateview {
    NSLog(@"---------i am in ok");
}
-(void)getCredit
{
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@userCredits_V2.php?objectType=get&deviceId=%@", API, DeviceId];
        NSLog(@"URL : %@", url);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if([getData length]>2)
        {
            NSDictionary *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", getArray);
                NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
                [UserDefaults setBool:[[getArray valueForKey:@"firstUser"] boolValue] forKey:SESSION_FIRSTUSER];
                [UserDefaults setInteger:[[getArray valueForKey:@"credit"] integerValue] forKey:SESSION_USERCREDITS];
                [UserDefaults synchronize];
                NSLog(@"synchronize");
            });
        }
    }
    @catch(NSException *juju)
    {
        //Play with your cute & beautiful exception.
        NSLog(@"Reporting juju from getCredit: %@", juju);
    }
}

#pragma mark Main Thread Segments

-(void)HandleError
{
    UIAlertView *showError=[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"Something is not right. Please try again later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Retry", nil];
    [showError setTag:13];
    [showError show];
}


-(void) gotCategories
{
    [[self Spinner] stopAnimating];
    [[self categoryTable] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    initialFrame=[BackView frame];
    initialFrame.size.height+=[CategoryArray count]*90;
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
    return [CategoryArray count];
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
    NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.frame = CGRectMake(3, 0, 313, 46);
        
    Method=[CategoryArray objectAtIndex:indexPath.row];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
   // cell.textLabel.textColor=[UIColor darkGrayColor];
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
    //return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.categoryTable deselectRowAtIndexPath:indexPath animated:YES];
    
    Method=[CategoryArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    cell=[tableView cellForRowAtIndexPath:indexPath];
    cardsView *CardViewNib=[[cardsView alloc] init];
    [CardViewNib setCardId:[Method Id]];
    [CardViewNib setCardName:[Method Name]];
    [[self navigationController] pushViewController:CardViewNib animated:YES];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view bringSubviewToFront:[self categoryTable]];
    if(initialFrame.size.height>0)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect TempRect=initialFrame;
//        if (offset.y>0) {
//            TempRect.origin.y-=offset.y-80;
//        } else {
            TempRect.origin.y-=offset.y;
        //}
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


@end
