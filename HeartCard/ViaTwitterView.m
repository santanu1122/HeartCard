//
//  ViaTwitterView.m
//  HeartCard
//
//  Created by Iphone_2 on 18/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "ViaTwitterView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViaTwitterView ()
{
    GlobalMethod *Method;
    NSOperationQueue *OperationQueueTwit;
    UIView *OverlayView;
    
}
@property (nonatomic,retain) IBOutlet UILabel *LblFrom;
@property (nonatomic,retain) IBOutlet UILabel *LblTo;
@property (nonatomic,retain) IBOutlet UITextField *UVBackTxt1;
@property (nonatomic,retain) IBOutlet UITextField *UVBackTxt2;
@property (nonatomic,retain) IBOutlet UIView *BottomBarView;
@property (strong, nonatomic) IBOutlet UIView *SendViaTwitterView;
@property (strong, nonatomic) IBOutlet UIView *SendViaTwitterScreenView;

-(IBAction)SendCardToTwitter:(id)sender;
-(IBAction)CancelCardToTwitter:(id)sender;
@end

@implementation ViaTwitterView

@synthesize TwitterFriendArray, TblTwitter, ScreenViewTwit, accountStore, UniqueCardId,LblFrom,LblTo,UVBackTxt1,UVBackTxt2,BottomBarView,SendViaTwitterView,SendViaTwitterScreenView;

@synthesize ParamChooseMsg, ParamCustomMsg, ParamUploadedImage, ParamSenderName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"ViaTwitterViewBig" bundle:nil]:[super initWithNibName:@"ViaTwitterView" bundle:nil];
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

-(void)viewDidAppear:(BOOL)animated
{
    
    [SendViaTwitterView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.ScreenViewTwit addSubview:SendViaTwitterView];
    
    CGRect TopTitleRect=CGRectMake(40.0f, 15.0f, 246.0f, 40.0f);
    UILabel *LblTopTitile=[[UILabel alloc] initWithFrame:TopTitleRect];
    [LblTopTitile setText:@"SEND YOUR CARD"];
    [LblTopTitile setBackgroundColor:[UIColor clearColor]];
    [LblTopTitile setTextAlignment:NSTextAlignmentCenter];
    [LblTopTitile setFont:[UIFont fontWithName:@"papyrus" size:19.0f]];
    [LblTopTitile setTextColor:UIColorFromRGB(0x0571af) ];
    [LblTopTitile setShadowColor:UIColorFromRGB(0xb8ddf2)];
    [SendViaTwitterScreenView addSubview:LblTopTitile];
    
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
    
    [SendViaTwitterView setHidden:YES];
}

-(void)PrepareScreen
{
    Method=[[GlobalMethod alloc] init];
    OperationQueueTwit=[[NSOperationQueue alloc] init];
    [self SetBackground:ScreenViewTwit];
    [self setHeaderSize:19.0f];
    [self AddTopBarToScreenView:ScreenViewTwit withTitle:@"SEND YOUR CARD" WithFavIcon:YES];
    [[self TblTwitter] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [TblTwitter reloadData];
}

-(void)goBack
{
    [self PerformGoBackTo:@"SendView"];
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
    return [TwitterFriendArray count];
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
    
   
    
    Method=[[GlobalMethod alloc] init];
    Method=[TwitterFriendArray objectAtIndex:indexPath.row];
    
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
    [self.TblTwitter deselectRowAtIndexPath:indexPath animated:YES];
    
    Method=[TwitterFriendArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    cell=[tableView cellForRowAtIndexPath:indexPath];
    
    
    [[self TblTwitter] setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
        [SendViaTwitterView setHidden:NO];
        
    } completion:^(BOOL finished) {
        
        [UVBackTxt1 setText:ParamSenderName];
        [UVBackTxt2 setText:[Method Name]];
    }];
    
  
}

#pragma marks for Thread Segments
-(IBAction)SendCardToTwitter:(id)sender
{
    
    UIView *BackView;
    BackView =[[[NSBundle mainBundle] loadNibNamed:@"AnimationView" owner:self options:nil] objectAtIndex:5];
    [BackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.90f]];
    [ScreenViewTwit addSubview:BackView];
    
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
    //[ObjectCarrier setObject:[TxtYourEmail text] forKey:@"email"];
    [ObjectCarrier setObject:[Method Id] forKey:@"twit"];
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
-(IBAction)CancelCardToTwitter:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
        [SendViaTwitterView setHidden:YES];
        
    } completion:^(BOOL finished) {
        
        [UVBackTxt1 setText:nil];
        [UVBackTxt2 setText:nil];
    }];
}

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
        NSString *url=[NSString stringWithFormat:@"%@SendCard_V2.php?rName=%@&name=%@&cardId=%@&message=%@&cMessage=%@&via=2&twit=%@&user_name=%@&deviceId=%@", API,  [Method Encoder:[Param objectForKey:@"rName"]], [Method Encoder:[Param objectForKey:@"name"]], UniqueCardId, [Method Encoder:[Param objectForKey:@"message1"]], [Method Encoder:[Param objectForKey:@"message2"]], [Param objectForKey:@"twit"], [Param objectForKey:@"user_name"], DeviceId];
        NSLog(@"%@", url);
        
        NSURL* requestURL = [NSURL URLWithString:url];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setURL:requestURL];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        NSURLResponse *response = nil;
        NSError *error;
        
        NSData *tempimg=(NSData *)[Param objectForKey:@"AttachtedImage"];
        
        if(tempimg)
        {
            NSString *boundary = [NSString stringWithFormat:@"%0.9u",arc4random()];
            
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[NSData dataWithData:tempimg]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
        }
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"ReturnString: %@", returnString);
        
        if([returnString length]>0)
        {
            
            NSLog(@"user_name------------ %@",[Param objectForKey:@"user_name"]);
            NSArray *ObjectCarrier=[[NSArray alloc] initWithObjects:[Param objectForKey:@"user_name"], returnString, nil];
            NSInvocationOperation *Invoc=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(PostOnTwitter:) object:ObjectCarrier];
            [OperationQueueTwit addOperation:Invoc];
            
            //[self performSelectorOnMainThread:@selector(PostOnTwitter:) withObject:ObjectCarrier waitUntilDone:NO];
        }
    }
    @catch(NSException *juju)
    {
        //Play with your little juju.
        NSLog(@"Reporting Juju :: %@", juju);
    }
}



-(void)PostOnTwitter :(NSArray *)ParamArray
{
    
    
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        if(!accountStore)
//            accountStore = [[ACAccountStore alloc] init];
//        
//        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//        
//        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
//             if(granted!=0) {
//                 
//                 NSArray *arrayOfAccounts = [self.accountStore accountsWithAccountType:accountType];
//                 
//                 if ([arrayOfAccounts count] > 0) {
//                     
//                     NSLog(@"arrayOfAccounts --- I am here");
//                     
//                     NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:accountType];
//                     
//                     NSURL *MsgUrl=[NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
//                     
//                     NSDictionary *Msgparams = @{@"screen_name" : [ParamArray objectAtIndex:0],@"text" : [ParamArray objectAtIndex:1]};
//                     
//                     SLRequest *MynewRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:MsgUrl parameters:Msgparams];
//                     
//                     [MynewRequest setAccount:[twitterAccounts lastObject]];
//                     
//                     [MynewRequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse,NSError *error){
//                         
//                         @try {
//                             NSLog(@"i am in try section");
//                             if (responseData) {
//                                 if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
//                                 {
//                                     NSError *jsonError;
//                                     
//                                     NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
//                                     
//                                     if (timelineData) {
//                                         
//                                         NSLog(@"success");
//                                         [self performSelectorOnMainThread:@selector(CardHasSent) withObject:nil waitUntilDone:NO];
//                                     } else {
//                                         
//                                         NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
//                                     }
//                                 }
//                             } else {
//                                 NSLog(@"The response status code is %d", urlResponse.statusCode);
//                             }
//                         }
//                         @catch (NSException *exception) {
//                             NSLog(@"i am in catch section");
//                             NSLog(@"There is exception in twitter request, and exception is --- %@",exception);
//                         }
//                        
//                     }];
//                     
//                 }
//             }
//         }];
//    }
    
    
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        if(!accountStore)
            accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
         {
             if(granted!=0)
             {
                 NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:accountType];
                 
                 NSURL *MsgUrl=[NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
                 
                 //NSLog(@"---------- %@",[ParamArray objectAtIndex:0]);
                // NSLog(@"---------- %@",[ParamArray objectAtIndex:1]);
                 
                 NSString *someStringUTF = [ParamArray objectAtIndex:1];
                 
                 NSString *mystring = [someStringUTF stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
                 
                 NSLog(@"mystring --- %@",mystring);
                 
                 NSDictionary *Msgparams = @{@"screen_name" : [ParamArray objectAtIndex:0], @"text" : [someStringUTF stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
                 
                 SLRequest *Msgrequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:MsgUrl parameters:Msgparams];
                 
                 
                 [Msgrequest setAccount:[twitterAccounts lastObject]];
                 
                 [Msgrequest performRequestWithHandler:^(NSData *responseData,NSHTTPURLResponse *urlResponse,NSError *error) {
                     
                     if (responseData) {
                        
                         NSLog(@"urlResponse.statusCode --- %d",urlResponse.statusCode);
                         
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             
                             NSError *jsonError;
                             
                             NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (timelineData) {
                                 
                                 NSLog(@"success");
                                 [self performSelectorOnMainThread:@selector(CardHasSent) withObject:nil waitUntilDone:NO];
                             } else {
                                 
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         } else {
                             
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                     
                 }];
                 
             }
         }];
    }
}

-(void)CardHasSent
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Card has been sent." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
