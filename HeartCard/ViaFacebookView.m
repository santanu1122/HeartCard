//
//  ViaFacebookView.m
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "ViaFacebookView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViaFacebookView ()
{
    GlobalMethod *Method;
    NSOperationQueue *OperationQueueTwit;
    UIView *OverlayView;
    BOOL IsFilterd;
    NSMutableArray *FilteredArray;
    
}

@property (nonatomic,retain) IBOutlet UILabel *LblFrom;
@property (nonatomic,retain) IBOutlet UILabel *LblTo;
@property (nonatomic,retain) IBOutlet UITextField *UVBackTxt1;
@property (nonatomic,retain) IBOutlet UITextField *UVBackTxt2;
@property (nonatomic,retain) IBOutlet UIView *BottomBarView;
-(IBAction)SendCardToFacebook:(id)sender;
-(IBAction)CancelCardToFacebook:(id)sender;
@end

@implementation ViaFacebookView

@synthesize FBFriendsArray, TblFB, ScreenViewFB,  UniqueCardId, TFSearch, VSearchBackView,LblFrom,LblTo,UVBackTxt1,UVBackTxt2,BottomBarView;

@synthesize ParamChooseMsg, ParamCustomMsg, ParamUploadedImage, ParamSenderName,SendViaFacebookScreenView,SendViaFacebookView;

int SelectedIndex = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"ViaFacebookViewBig" bundle:nil]:[super initWithNibName:@"ViaFacebookView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self PrepareScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)PrepareScreen
{
    IsFilterd=FALSE;
    FilteredArray=[[NSMutableArray alloc] init];
    
    Method=[[GlobalMethod alloc] init];
    OperationQueueTwit=[[NSOperationQueue alloc] init];
    [self SetBackground:ScreenViewFB];
    [self setHeaderSize:19.0f];
    [self AddTopBarToScreenView:ScreenViewFB withTitle:@"SEND YOUR CARD" WithFavIcon:YES];
    [[self TblFB] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[VSearchBackView layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    [[VSearchBackView layer] setBorderWidth:1.0f];
    
    [TblFB reloadData];
    
    [SendViaFacebookView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.ScreenViewFB addSubview:SendViaFacebookView];
    
    CGRect TopTitleRect=CGRectMake(40.0f, 15.0f, 246.0f, 40.0f);
    UILabel *LblTopTitile=[[UILabel alloc] initWithFrame:TopTitleRect];
    [LblTopTitile setText:@"SEND YOUR CARD"];
    [LblTopTitile setBackgroundColor:[UIColor clearColor]];
    [LblTopTitile setTextAlignment:NSTextAlignmentCenter];
    [LblTopTitile setFont:[UIFont fontWithName:@"papyrus" size:19.0f]];
    [LblTopTitile setTextColor:UIColorFromRGB(0x0571af) ];
    [LblTopTitile setShadowColor:UIColorFromRGB(0xb8ddf2)];
    [SendViaFacebookScreenView addSubview:LblTopTitile];
    
    [TFSearch addTarget:self action:@selector(FilterResult) forControlEvents:UIControlEventEditingChanged];
    
    [self SetFontToLabel:LblFrom withSize:14.0f];
    [self SetFontToLabel:LblTo withSize:14.0f];
    [LblFrom setTextColor:UIColorFromRGB(0xc88e00)];
    [LblTo setTextColor:UIColorFromRGB(0xc88e00)];
    
    [[[UVBackTxt1 superview] layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    [[[UVBackTxt2 superview] layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    
    [[[UVBackTxt1 superview] layer] setBorderWidth:1.0f];
    [[[UVBackTxt2 superview] layer] setBorderWidth:1.0f];
    
    [UVBackTxt1 setFont:[UIFont fontWithName:@"papyrus" size:12.0f]];
    [UVBackTxt2 setFont:[UIFont fontWithName:@"papyrus" size:12.0f]];
    
    [UVBackTxt1 setUserInteractionEnabled:NO];
    [UVBackTxt2 setUserInteractionEnabled:NO];
    
    [SendViaFacebookView setHidden:YES];
    
}

-(void)goBack
{
    [self PerformGoBackTo:@"SendView"];
}

#pragma mark for Delegates


-(void)FilterResult
{    
    [FilteredArray removeAllObjects];
    if([[TFSearch text] length]>0)
    {
        IsFilterd=TRUE;
        for(GlobalMethod *LocalMethod in FBFriendsArray)
        {
            NSRange TextRange=[[LocalMethod Name] rangeOfString:[TFSearch text] options:NSCaseInsensitiveSearch];
            if(TextRange.location != NSNotFound)
                [FilteredArray addObject:LocalMethod];
        }
    }
    else
    {
        IsFilterd=FALSE;
    }
    [[self TblFB] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [[self view] endEditing:YES];
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
    return (IsFilterd)?[FilteredArray count]:[FBFriendsArray count];
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
    
    cell= [[UITableViewCell alloc] init];
    cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=[[[NSBundle mainBundle] loadNibNamed:@"friendsCell" owner:self options:nil] objectAtIndex:0];
    
    Method=(IsFilterd)?[FilteredArray objectAtIndex:[indexPath row]]:[FBFriendsArray objectAtIndex:[indexPath row]];
    
    UILabel *FriendsName=(UILabel *)[cell viewWithTag:2];
    [FriendsName setFont:[UIFont fontWithName:@"Papyrus" size:15]];
    [FriendsName setText:[Method Name]];
    [FriendsName setTextColor:UIColorFromRGB(0xe8661c)];
    
    UIImageView *FriendImage = (UIImageView *) [cell viewWithTag:1];
    [[FriendImage layer] setBorderColor:[UIColorFromRGB(0xe8661c) CGColor]];
    [[FriendImage layer] setBorderWidth:1.0f];
    
    NSArray *ObjectCarrier=[[NSArray alloc] initWithObjects:FriendImage, [Method ImageUrl], @"3", nil];
    [self LoadImage:ObjectCarrier];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self TblFB] deselectRowAtIndexPath:indexPath animated:YES];
    [[self view] endEditing:YES];
    
    SelectedIndex = indexPath.row;
    
    Method=(IsFilterd)?[FilteredArray objectAtIndex:[indexPath row]]:[FBFriendsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    cell=[tableView cellForRowAtIndexPath:indexPath];
    
    
//    [[self TblFB] setUserInteractionEnabled:NO];
//    
//    UIView *BackView;
//    
//    BackView =[[[NSBundle mainBundle] loadNibNamed:@"AnimationView" owner:self options:nil] objectAtIndex:5];
//    [BackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.90f]];
//    [ScreenViewFB addSubview:BackView];
//    
//    UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150.0f, 212.0f, 37.0f, 37.0f)];
//    [spinner startAnimating];
//    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [BackView addSubview:spinner];
//    
//    UILabel *ProgressLbl=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 260.0f, 320.0f, 30.0f)];
//    [ProgressLbl setBackgroundColor:[UIColor clearColor]];
//    [ProgressLbl setTextColor:[UIColor whiteColor]];
//    [ProgressLbl setTextAlignment:NSTextAlignmentCenter];
//    [ProgressLbl setText:@"Please wait..."];
//    [BackView addSubview:ProgressLbl];
//    [self SetFontToLabel:ProgressLbl withSize:20.0f];
    
    
    
    [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
        [SendViaFacebookView setHidden:NO];
        
    } completion:^(BOOL finished) {
        
        [UVBackTxt1 setText:ParamSenderName];
        [UVBackTxt2 setText:[Method Name]];
    }];
    
//    [self ChangeCredit];
//    
//    NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(SendViaEmail:) object:ObjectCarrier];
//    [OperationQueueTwit addOperation:Invoc];
}
-(IBAction)SendCardToFacebook:(id)sender {
    
    [[self TblFB] setUserInteractionEnabled:NO];
    
    UIView *BackView;
    
    BackView =[[[NSBundle mainBundle] loadNibNamed:@"AnimationView" owner:self options:nil] objectAtIndex:5];
    [BackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.90f]];
    [ScreenViewFB addSubview:BackView];
    
    UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150.0f, 212.0f, 37.0f, 37.0f)];
    [spinner startAnimating];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [BackView addSubview:spinner];
    
    UILabel *ProgressLbl=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 260.0f, 320.0f, 30.0f)];
    [ProgressLbl setBackgroundColor:[UIColor clearColor]];
    [ProgressLbl setTextColor:[UIColor whiteColor]];
    [ProgressLbl setTextAlignment:NSTextAlignmentCenter];
    [ProgressLbl setText:@"Please wait..."];
    [BackView addSubview:ProgressLbl];
    [self SetFontToLabel:ProgressLbl withSize:20.0f];
    
    NSMutableDictionary *ObjectCarrier;
    ObjectCarrier=[[NSMutableDictionary alloc] init];
    [ObjectCarrier setObject:ParamSenderName forKey:@"name"];
    [ObjectCarrier setObject:[Method Id] forKey:@"fb"];
    [ObjectCarrier setObject:[Method Name] forKey:@"rName"];
    // [ObjectCarrier setObject:[TxtSelectDate text] forKey:@"sendDate"];
    if(ParamUploadedImage)
    {
        [ObjectCarrier setObject:ParamUploadedImage forKey:@"AttachtedImage"];
    }
    [ObjectCarrier setObject:ParamChooseMsg forKey:@"message1"];
    [ObjectCarrier setObject:ParamCustomMsg forKey:@"message2"];
    [ObjectCarrier setObject:[Method UserName] forKey:@"user_name"];

    [self ChangeCredit];
    NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(SendViaEmail:) object:ObjectCarrier];
    [OperationQueueTwit addOperation:Invoc];
}
-(IBAction)CancelCardToFacebook:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
        [SendViaFacebookView setHidden:YES];
        
    } completion:^(BOOL finished) {
        
        [UVBackTxt1 setText:nil];
        [UVBackTxt2 setText:nil];
    }];
}

#pragma marks for Thread Segments

-(void)ChangeCredit
{
    
    NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
    
    int NewCredit=(int)[UserDefaults integerForKey:SESSION_USERCREDITS];
    NewCredit-=1;
    
    [UserDefaults setInteger:NewCredit forKey:SESSION_USERCREDITS];
    [UserDefaults synchronize];
    
    NSString *URL=[NSString stringWithFormat:@"%@userCredits_V2.php?objectType=set&TotalCredit=%d&deviceId=%@", API, NewCredit, DeviceId];
    NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Fire:) object:URL];
    [OperationQueueTwit addOperation:Operation];
}

-(void)Fire:(NSString *)URL
{
    @try
    {
        NSLog(@"%@", URL);
        [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from Fire: %@", juju);
    }
}

-(void)SendViaEmail:(NSMutableDictionary *)Param
{
    @try
    {
        // NSLog(@"%@", Param);
        NSString *url=[NSString stringWithFormat:@"%@SendCard_V2.php?rName=%@&name=%@&cardId=%@&message=%@&cMessage=%@&via=3&fb=%@&user_name=%@&deviceId=%@", API,  [Method Encoder:[Param objectForKey:@"rName"]], [Method Encoder:[Param objectForKey:@"name"]], UniqueCardId, [Method Encoder:[Param objectForKey:@"message1"]], [Method Encoder:[Param objectForKey:@"message2"]], [Param objectForKey:@"fb"], [Param objectForKey:@"user_name"], DeviceId];
        NSLog(@"%@", url);
        
        NSURL* requestURL = [NSURL URLWithString:url];
        
        NSData *imageData = imageData;
        // setting up the URL to post to
        NSString *urlString = url;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:[Param objectForKey:@"AttachtedImage"]]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // now lets make the connection to the web
       // returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"ReturnString: %@", returnString);
        
        if([returnString isEqualToString:@"Success"])
        {
            [self performSelectorOnMainThread:@selector(CardHasSent) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(CardHasSentError) withObject:nil waitUntilDone:NO];
        }
    }
    @catch(NSException *juju)
    {
        //Play with your little juju.
        NSLog(@"Reporting Juju :: %@", juju);
    }
}


-(void)CardHasSent
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Card has been sent." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)CardHasSentError
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Failed to send the card." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self PerformGoBackTo:@"CategoryView"];
    }
}

@end
