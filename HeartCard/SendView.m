//
//  SendView.m
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "SendView.h"
#import "ViaTextMessageView.h"
#import "ViaEmailView.h"
#import "ViaTwitterView.h"
#import "ViaFacebookView.h"
#import "AppDelegate.h"
#import "TIAPHelper.h"

@interface SendView () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
  
}

@end

@implementation SendView

@synthesize ScreenViewSend, UniqueCardId;
@synthesize ParamChooseMsg, ParamCustomMsg, ParamUploadedImage, accountStore, BtnTwitter, LblErrorSend, BtnEmail, BtnFacebook, BtnTextMessage, Spinner;

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

UIView *VOverLayWaitScreenT;
NSArray *_products;

SKProductsRequest * _productsRequest;
RequestProductsCompletionHandler _completionHandler;
NSSet * _productIdentifiers;
NSMutableSet * _purchasedProductIdentifiers;
int UserCredits;
NSOperationQueue *OperationQueueForSend;
UILabel *LblProduct1Title, *LblProduct2Title, *LblProduct1Price, *LblProduct2Price;

NSString *TwitterId, *TwitterScreenName, *SenderName, *LastSenderName, *LastSenderEmail;

NSMutableArray *TwitterFriendsArray, *FriendsArray;


GlobalMethod *Method;

BOOL IsFBThreadFired, IsFirstUser;
UIView *VOverlay, *BottomBarView;


+ (TIAPHelper *)sharedInstance
{
    static dispatch_once_t once;
    static TIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects: @"HCAP001", @"HCAP002", nil];
        NSLog(@"productIdentifiers ------ %@",productIdentifiers);
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    
    if ((self = [super init]))
    {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"SendViewBig" bundle:nil]:[super initWithNibName:@"SendView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getAllProducts];
    [self PrepareScreen];
    [self ShowUserCredits];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [LblErrorSend setText:@""];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self EnableAll];
}


-(void)getAllProducts
{
    [[SendView sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if(success)
         {
             _products=products;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                
                 NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                 [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];                 
                 SKProduct *TempProduct1=[_products objectAtIndex:0];
                 
                 [LblProduct1Title setText:TempProduct1.localizedTitle];
                 [formatter setLocale:TempProduct1.priceLocale];
                 [LblProduct1Price setText:[formatter stringFromNumber:TempProduct1.price]];
                 
                 NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
                 [formatter1 setNumberStyle:NSNumberFormatterCurrencyStyle];
                 SKProduct *TempProduct2=[_products objectAtIndex:1];
                 
                 [LblProduct2Title setText:TempProduct2.localizedTitle];
                 [formatter1 setLocale:TempProduct2.priceLocale];
                 [LblProduct2Price setText:[formatter1 stringFromNumber:TempProduct2.price]];
                 
                 [self EndWait];
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                
                 [self EndWait];
                 [self ThankYouNowTakeMeBack];
                 
             });
         }
     }];
}

-(void)ShowUserCredits
{
    NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
    
    IsFirstUser=(BOOL)[UserDefaults boolForKey:SESSION_FIRSTUSER];
    UserCredits=(int)[UserDefaults integerForKey:SESSION_USERCREDITS];
    
    VOverlay=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [ScreenViewSend frame].size.width, [ScreenViewSend frame].size.height)];
    [VOverlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7f]];
    [VOverlay setAlpha:0.0f];
    [[self ScreenViewSend] addSubview:VOverlay];
    
    [UIView animateWithDuration:0.7f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [VOverlay setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        [self AddButtomBar];
    }];
    
    int LoadObjectAtIndex=0;
    if(IsFirstUser)
    {
        LoadObjectAtIndex=(IsIphone5)?3:2;
    }
    else
    {
        LoadObjectAtIndex=(IsIphone5)?5:4;
    }
    
    UIView *VSubOverlay=[[[NSBundle mainBundle] loadNibNamed:@"ExtendedAnimationView" owner:self options:nil] objectAtIndex:LoadObjectAtIndex];
    [VOverlay addSubview:VSubOverlay];

    LblProduct1Title=(UILabel *)[VSubOverlay viewWithTag:1];
    LblProduct1Price=(UILabel *)[VSubOverlay viewWithTag:2];
    LblProduct2Title=(UILabel *)[VSubOverlay viewWithTag:3];
    LblProduct2Price=(UILabel *)[VSubOverlay viewWithTag:4];
    
    UIButton *btnBuy5=(UIButton *)[VSubOverlay viewWithTag:5];
    UIButton *btnBuy10=(UIButton *)[VSubOverlay viewWithTag:6];
    
    [btnBuy5 addTarget:self action:@selector(Buy5) forControlEvents:UIControlEventTouchUpInside];
    [btnBuy10 addTarget:self action:@selector(Buy10) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *LblCredits=(UILabel *)[VSubOverlay viewWithTag:7];
    [LblCredits setText:[NSString stringWithFormat:@"%d", UserCredits]];
    
    [self PleaseWait];
}


-(void)PleaseWait
{
    NSLog(@"PleaseWait");
    
    CGRect Rect=[[UIScreen mainScreen] bounds];
    VOverLayWaitScreenT=[[[NSBundle mainBundle] loadNibNamed:@"ExtendedAnimationView" owner:self options:nil] objectAtIndex:6];
    [VOverLayWaitScreenT setFrame:Rect];
    [VOverLayWaitScreenT setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.80f]];
    [VOverLayWaitScreenT setAlpha:0.0f];
    [VOverLayWaitScreenT setTag:9098];
    [ScreenViewSend addSubview:VOverLayWaitScreenT];
    
    [UIView  animateWithDuration:0.3 animations:^{
        
        [VOverLayWaitScreenT setAlpha:1.0f];
        
    }];
}

-(void)EndWait
{
    [UIView  animateWithDuration:0.3 animations:^{
        
        [VOverLayWaitScreenT setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        [VOverLayWaitScreenT removeFromSuperview];
        
    }];

}

-(void)AddButtomBar
{
    float FromTopForMain=(IsIphone5)?513.0f:435.0f;
    FromTopForMain+=50.0f;
    CGRect BottombarRect=CGRectMake(0.0f, FromTopForMain, 320.0f, 85.0f);
    
    float FormTop=40.0f;
    
    BottomBarView=[[UIView alloc] initWithFrame:BottombarRect];
    [BottomBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar.png"]]];
    [VOverlay addSubview:BottomBarView];
    
    CGRect Button1Rect, Button2Rect;
    
    NSLog(@"IsFirstUser ---- %d ----- %hhd",UserCredits,IsFirstUser);
    
    if(IsFirstUser || UserCredits<=0)
    {
        Button1Rect=CGRectMake(124.0f, FormTop, 72.0f, 36.0f);
        UIButton *Button1=[[UIButton alloc] initWithFrame:Button1Rect];
        [Button1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [Button1 addTarget:self action:@selector(ThankYouNowTakeMeBack) forControlEvents:UIControlEventTouchUpInside];
        [BottomBarView addSubview:Button1];
    }
    else
    {
        Button1Rect=CGRectMake(34.0f, FormTop, 72.0f, 36.0f);
        UIButton *Button1=[[UIButton alloc] initWithFrame:Button1Rect];
        [Button1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [Button1 addTarget:self action:@selector(ThankYouNowTakeMeBack) forControlEvents:UIControlEventTouchUpInside];
        [BottomBarView addSubview:Button1];
        
        Button2Rect=CGRectMake(214.0f, FormTop, 72.0f, 36.0f);
        UIButton *Button2=[[UIButton alloc] initWithFrame:Button2Rect];
        [Button2 setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
        [Button2 addTarget:self action:@selector(ItsOkShowMeSendOptions) forControlEvents:UIControlEventTouchUpInside];
        [BottomBarView addSubview:Button2];
    }
    
    [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
        
        CGRect tempRect=[BottomBarView frame];
        tempRect.origin.y-=80.0f;
        [BottomBarView setFrame:tempRect];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)PrepareScreen
{
    [self SetBackground:ScreenViewSend];
    [self setHeaderSize:19.0f];
   // [self AddTopBarToScreenView:ScreenViewSend withTitle:@"SEND YOUR CARD" WithFavIcon:YES];
    
    CGRect TopbarRect=CGRectMake(0.0f, 0.0f, 320.0f, 77.0f);
    UIView *TopbarView=[[UIView alloc] initWithFrame:TopbarRect];
    [TopbarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar-bg.png"]]];
    [ScreenViewSend addSubview:TopbarView];
    
    CGRect BackButtonRect=CGRectMake(10.0f, 18.0f, 30.0f, 25.0f);
    UIButton *backButton=[[UIButton alloc] initWithFrame:BackButtonRect];
    [backButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackNewOne) forControlEvents:UIControlEventTouchUpInside];
    [TopbarView addSubview:backButton];
    
    CGRect TopTitleRect=CGRectMake(40.0f, 15.0f, 246.0f, 40.0f);
    UILabel *LblTopTitile=[[UILabel alloc] initWithFrame:TopTitleRect];
    [LblTopTitile setText:@"SEND YOUR CARD"];
    [LblTopTitile setBackgroundColor:[UIColor clearColor]];
    [LblTopTitile setTextAlignment:NSTextAlignmentCenter];
    [LblTopTitile setFont:[UIFont fontWithName:@"papyrus" size:19.0f]];
    [LblTopTitile setTextColor:UIColorFromRGB(0x0571af) ];
    [LblTopTitile setShadowColor:UIColorFromRGB(0xb8ddf2)];
    [TopbarView addSubview:LblTopTitile];
    
    CGRect FavButtonRect=CGRectMake(276.0f, 18.0f, 34.0f, 29.0f);
    FavButton=[[UIButton alloc] initWithFrame:FavButtonRect];
    [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    [FavButton addTarget:self action:@selector(FavButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [TopbarView addSubview:FavButton];
    
    
    [self SetFontToLabel:LblErrorSend withSize:14.0f];
    
    TwitterFriendsArray=[[NSMutableArray alloc] init];
    FriendsArray=[[NSMutableArray alloc] init];
    
    OperationQueueForSend=[[NSOperationQueue alloc] init];
    
    Method=[[GlobalMethod alloc] init];
    
    IsFBThreadFired=FALSE;
    
    LastSenderName=@"";
    LastSenderEmail=@"";
    
    [[self LblErrorSend] setTextAlignment:NSTextAlignmentCenter];
    [[self LblErrorSend] setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getLastSenderInfo) object:nil];
    [OperationQueueForSend addOperation:Operation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:@"transactionFailed" object:nil];
}

-(void)goBackNewOne {
    NSLog(@"i am here");
    [self PerformGoBackTo:@"cardsView"];
}

-(void)notificationReceived:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"transactionFailed"])
    {
        [self PerformGoBack];
    }
}


-(void)ThankYouNowTakeMeBack
{
    [UIView animateWithDuration:0.5f animations:^{
        
        CGRect tempRect=[BottomBarView frame];
        tempRect.origin.y+=80.0f;
        [BottomBarView setFrame:tempRect];
        [VOverlay setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        [VOverlay removeFromSuperview];
        [self goBack];
    }];
}



-(void)ItsOkShowMeSendOptions
{
    [UIView animateWithDuration:0.6f animations:^{
        
        CGRect tempRect=[BottomBarView frame];
        tempRect.origin.y+=60.0f;
        [BottomBarView setFrame:tempRect];
        [VOverlay setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        [VOverlay removeFromSuperview];
        
    }];
}



-(void)goBack
{
    //[self PerformGoBackTo:@"cardsView"];
    //[self PerformGoBack];
    [self performSelectorOnMainThread:@selector(PerformGoBack) withObject:Nil waitUntilDone:YES];
}


-(void)Buy5
{
    [self PleaseWait];
    SKProduct *SelectedProducts=[_products objectAtIndex:0];
    [[SendView sharedInstance] buyProduct:SelectedProducts];
}

-(void)Buy10
{
    [self PleaseWait];
    SKProduct *SelectedProducts=[_products objectAtIndex:1];
    [[SendView sharedInstance] buyProduct:SelectedProducts];
}


- (IBAction)BtnFBTouched:(id)sender
{
    if([FriendsArray count]>0)
    {
        [self gotFBGoNow];
    }
    else
    {
        IsFBThreadFired=FALSE;
        [[FBSession activeSession] closeAndClearTokenInformation];
        [[FBSession activeSession] close];
        [FBSession setActiveSession:nil];
        [self DisableAll];
        [self CallFacebook];
    }
}

- (IBAction)BtnTwitTouched:(id)sender
{
    if([TwitterFriendsArray count]>0)
    {
        [self gotTwitterGoNow];
    }
    else
    {
        [self DisableAll];
        [self CallTwitter];
    }
}

- (IBAction)BtnEmailTouched:(id)sender
{
    ViaEmailView *ViaEmailViewNib=[[ViaEmailView alloc] init];
    [ViaEmailViewNib setUniqueCardId:UniqueCardId];
    [ViaEmailViewNib setParamChooseMsg:ParamChooseMsg];
    [ViaEmailViewNib setParamCustomMsg:ParamCustomMsg];
    [ViaEmailViewNib setParamUploadedImage:ParamUploadedImage];
    [ViaEmailViewNib setParamLastSenderEmail:LastSenderEmail];
    [ViaEmailViewNib setParamLastSenderName:LastSenderName];
    [[self navigationController] pushViewController:ViaEmailViewNib animated:YES];
}

- (IBAction)BtnMessageTouched:(id)sender
{
    ViaTextMessageView *ViaTextMessageViewNib=[[ViaTextMessageView alloc] init];
    [ViaTextMessageViewNib setUniqueCardId:UniqueCardId];
    [ViaTextMessageViewNib setParamChooseMsg:ParamChooseMsg];
    [ViaTextMessageViewNib setParamCustomMsg:ParamCustomMsg];
    [ViaTextMessageViewNib setParamUploadedImage:ParamUploadedImage];
    [ViaTextMessageViewNib setParamLastSenderName:LastSenderName];
    [[self navigationController] pushViewController:ViaTextMessageViewNib animated:YES];
}

-(void)EnableAll
{
    [Spinner stopAnimating];
    [BtnTwitter setUserInteractionEnabled:YES];
    [BtnEmail setUserInteractionEnabled:YES];
    [BtnFacebook setUserInteractionEnabled:YES];
    [BtnTextMessage setUserInteractionEnabled:YES];
    [[self view] setUserInteractionEnabled:YES];
}

-(void)DisableAll
{
    [Spinner startAnimating];
    [BtnTwitter setUserInteractionEnabled:NO];
    [BtnEmail setUserInteractionEnabled:NO];
    [BtnFacebook setUserInteractionEnabled:NO];
    [BtnTextMessage setUserInteractionEnabled:NO];
    [[self view] setUserInteractionEnabled:NO];
}

#pragma mark for Thread Segments


-(void)getLastSenderInfo
{
    @try
    {
        NSString *URL=[NSString stringWithFormat:@"%@getLastSenderInfo.php?deviceId=%@", API, DeviceId];
        NSLog(@"%@", URL);
        NSData *getData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>2)
        {
            NSDictionary *Output=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            LastSenderEmail=(![[Output valueForKey:@"sender_email"] isEqualToString:@""])?[Output valueForKey:@"sender_email"]:@"";
            LastSenderName=(![[Output valueForKey:@"sender_name"] isEqualToString:@""])?[Output valueForKey:@"sender_name"]:@"";
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getLastSenderInfo: %@", juju);
    }
}

-(void)ChangeCredit:(int)uCredit TransactionIdentifier :(NSString *)TransactionIdentifier Product :(SKProduct *)Product
{
    int NewCredit=UserCredits+uCredit;
    NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
    [UserDefaults setInteger:NewCredit forKey:SESSION_USERCREDITS];
    [UserDefaults setBool:NO forKey:SESSION_FIRSTUSER];
    [UserDefaults synchronize];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:Product.priceLocale];
    
    NSString *Credits=[formatter stringFromNumber:Product.price];
  
    
    NSString *URL=[NSString stringWithFormat:@"%@userCredits_V2.php?objectType=set&TotalCredit=%d&deviceId=%@&credit=%d&credit_value=%@&keepHistory=yes", API, NewCredit, DeviceId, uCredit, [Method Encoder:Credits]];
    NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Fire:) object:URL];
    [OperationQueueForSend addOperation:Operation];
    [self ItsOkShowMeSendOptions];
}

-(void)Fire:(NSString *)URL
{
    @try
    {
        NSData* getData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
        NSLog(@"%@ || %@", URL, getData);
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from Fire: %@", juju);
    }
}





#pragma Twitter

-(void)CallTwitter
{
    @try
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {       
            if(!accountStore)
                accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
             {
                 if(granted!=0)
                 {
                     NSArray *twitterAccounts =
                     
                     [self.accountStore accountsWithAccountType:accountType];
                     
                     NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                     if ([accountsArray count] > 0)
                     {
                         ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                         NSString *userID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                         
                         
                         NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                         
                         
                         
                         NSDictionary *params = @{@"user_id" : userID,
                         
                         @"cursor" : @"-1",
                         
                         @"skip_status" : @"true",
                         
                         @"include_user_entities" : @"false"};
                         
                         SLRequest *request =
                         
                         [SLRequest requestForServiceType:SLServiceTypeTwitter
                          
                                            requestMethod:SLRequestMethodGET
                          
                                                      URL:url
                          
                                               parameters:params];
                         
                         [request setAccount:[twitterAccounts lastObject]];
                         
                         [request performRequestWithHandler:^(NSData *responseData,
                                                              
                                                              NSHTTPURLResponse *urlResponse,
                                                              
                                                              NSError *error) {
                             
                             if (responseData)
                             {
                                 if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                                 {
                                     NSError *jsonError;
                                     
                                     NSDictionary *timelineData =
                                     
                                     [NSJSONSerialization
                                      
                                      JSONObjectWithData:responseData
                                      
                                      options:NSJSONReadingAllowFragments error:&jsonError];
                                     
                                     
                                     if (timelineData)
                                     {
                                         TwitterId=[timelineData valueForKey:@"id"];
                                         TwitterScreenName=[timelineData valueForKey:@"screen_name"];
                                         SenderName=([[timelineData valueForKey:@"name"] length]>0)?[timelineData valueForKey:@"name"]:TwitterScreenName;
                                         [self getTwitterFeed];
                                     }
                                 }
                                 
                                 else
                                 {
                                     NSLog(@"The response status code is %d", urlResponse.statusCode);
                                 }
                             }
                             
                         }];
                         
                         
                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self EnableAll];
                             [LblErrorSend setText:@"Please setup your twitter account from your iphone/ipod settings"];
                         });
                     }
                     
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self EnableAll];
                         [LblErrorSend setText:@"Please setup your twitter account from your iphone/ipod settings"];
                     });
                     
                 }
             }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self EnableAll];
                [LblErrorSend setText:@"Please setup your twitter account from your iphone/ipod settings"];
            });

        }
    }
    @catch (NSException *juju)
    {
        //play with your little juju.
    }
}

-(void)ShowAlert:(NSString *)Message
{
    [LblErrorSend setText:Message];
    [ScreenViewSend bringSubviewToFront:LblErrorSend];
}


-(void)getTwitterFeed
{
    @try
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            if(!accountStore)
                accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
             {
                 if(granted!=0)
                 {
                     NSArray *twitterAccounts =
                     
                     [self.accountStore accountsWithAccountType:accountType];
                     
                     NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
                     NSLog(@"%@", TwitterScreenName);
                     
                     
                     NSDictionary *params = @{@"screen_name" : TwitterScreenName,
                     
                     @"cursor" : @"-1",
                     
                     @"skip_status" : @"true",
                     
                     @"include_user_entities" : @"false"};
                     
                     SLRequest *request =
                     
                     [SLRequest requestForServiceType:SLServiceTypeTwitter
                      
                                        requestMethod:SLRequestMethodGET
                      
                                                  URL:url
                      
                                           parameters:params];
                     
                     [request setAccount:[twitterAccounts lastObject]];
                     
                     [request performRequestWithHandler:^(NSData *responseData,
                                                          
                                                          NSHTTPURLResponse *urlResponse,
                                                          
                                                          NSError *error) {
                         
                         if (responseData)
                         {
                             
                             if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                             {
                                 
                                 NSError *jsonError;
                                 
                                 NSDictionary *timelineData =
                                 
                                 [NSJSONSerialization
                                  
                                  JSONObjectWithData:responseData
                                  
                                  options:NSJSONReadingAllowFragments error:&jsonError];
                                 
                                 if (timelineData)
                                 {
                                     NSArray *UsersArray=[timelineData objectForKey:@"users"];
                                     
                                     for(NSDictionary *var in UsersArray)
                                     {
                                         NSLog(@"%@ || %@", [var objectForKey:@"screen_name"], [var objectForKey:@"id"]);
                                         [TwitterFriendsArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"id"] withName:[var objectForKey:@"name"] withImageUrl:[var objectForKey:@"profile_image_url"] withUserName:[var objectForKey:@"screen_name"]]];
                                         
                                         
                                     }
                                     
                                     NSLog(@"%@", TwitterFriendsArray);
                                     
                                     [self performSelectorOnMainThread:@selector(gotTwitterGoNow) withObject:nil waitUntilDone:YES];
                                     
                                 }
                             }
                         }
                         
                     }];
                     
                 }
             }];
        }
    }
    
    @catch (NSException *juju)
    {
        //play with your little juju.
        //[self performSelectorOnMainThread:@selector(HandleError) withObject:nil waitUntilDone:YES];
    }
    

}

-(void)gotTwitterGoNow
{  
    [self EnableAll];
    [BtnTwitter setUserInteractionEnabled:YES];
    ViaTwitterView *ViaTwitterViewNib=[[ViaTwitterView alloc] init];
    [ViaTwitterViewNib setTwitterFriendArray:TwitterFriendsArray];
    [ViaTwitterViewNib setParamChooseMsg:ParamChooseMsg];
    [ViaTwitterViewNib setParamCustomMsg:ParamCustomMsg];
    [ViaTwitterViewNib setParamSenderName:SenderName];
    [ViaTwitterViewNib setParamUploadedImage:ParamUploadedImage];
    [ViaTwitterViewNib setUniqueCardId:UniqueCardId];
    [[self navigationController] pushViewController:ViaTwitterViewNib animated:YES];
}




#pragma mark for FB


-(void)CallFacebook
{
    if (FBSession.activeSession.isOpen)
    {
        [self updateView];
    }
    else
    {
        [self openSessionWithAllowLoginUI:YES];
        [self updateView];
    }
}


- (void)updateView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
        
        FBAccessToken=appDelegate.session.accessTokenData.accessToken;
        
        
        if(![FBAccessToken isEqual:@""] && !IsFBThreadFired)
        {
            IsFBThreadFired=TRUE;
            NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getDetails) object:nil];
            [OperationQueueForSend addOperation:Operation];
        }
    }
    else
    {
        // login-needed account UI is shown whenever the session is closed
    }
}


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_birthday",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.session=session;
                
                [self updateView];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please Allow happy heART cards to access your account."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void) getDetails
{
    @try
    {            
        NSString *url=[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", FBAccessToken];
        NSLog(@"%@", url);
        NSError *gotError;
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if([getData length]>0)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:&gotError];
            NSLog(@"%@", getArray);
            if(!gotError)
            {
                FBUID=[getArray valueForKey:@"id"];
                SenderName=[NSString stringWithFormat:@"%@ %@",[getArray valueForKey:@"first_name"],[getArray valueForKey:@"last_name"] ];
                NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getFacebookFeed) object:nil];
                [OperationQueueForSend addOperation:Operation];
            }
            else
            {
                NSLog(@"%@",gotError.localizedDescription);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self EnableAll];
                    [LblErrorSend setText:@"Please allow happy heART cards to access you account."];
                });
            }
        }
        else
        {
            NSLog(@"Data is null..");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self EnableAll];
                [LblErrorSend setText:@"Please allow happy heART cards to access you account."];
            });
        }
    }
    @catch (NSException *juju)
    {
        //play with your little juju.
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self EnableAll];
            [LblErrorSend setText:@"Please allow happy heART cards to access you account."];
        });
    }
}


-(void)getFacebookFeed
{
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@facebookFeed.php?fbId=%@&access_token=%@", API, [Method Encoder:FBUID], [Method Encoder:FBAccessToken]];
        NSLog(@"%@", url);
        
        NSData *getData=[NSData dataWithContentsOfURL:[Method ConvertStringToNSUrl:url]];
        
        if([getData length]>2)
        {
            NSLog(@"length :: %d",[getData length]);
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            for(NSDictionary *var in getArray)
            {
                [FriendsArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"id"] withName:[var objectForKey:@"name"] withImageUrl:[Method ConvertStringToNSUrl:[var objectForKey:@"pic"]] withIdentifier:[[var objectForKey:@"identifier"] integerValue] withUserName:[var objectForKey:@"username"]]];
            }
            [self performSelectorOnMainThread:@selector(gotFBGoNow) withObject:nil waitUntilDone:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self EnableAll];
                [LblErrorSend setText:@"Please allow happy heART cards to access you account."];
            });
        }
    }
    @catch (NSException *juju)
    {
        //play with your little juju.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self EnableAll];
            [LblErrorSend setText:@"Please allow happy heART cards to access you account."];
        });
    }
}


-(void)gotFBGoNow
{
    [self EnableAll];

    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];

    ViaFacebookView *ViaFacebookViewNib=[[ViaFacebookView alloc] init];
    [ViaFacebookViewNib setFBFriendsArray:FriendsArray];
    [ViaFacebookViewNib setParamChooseMsg:ParamChooseMsg];
    [ViaFacebookViewNib setParamCustomMsg:ParamCustomMsg];
    [ViaFacebookViewNib setParamSenderName:SenderName];
    [ViaFacebookViewNib setParamUploadedImage:ParamUploadedImage];
    [ViaFacebookViewNib setUniqueCardId:UniqueCardId];
    
    [[self navigationController] pushViewController:ViaFacebookViewNib animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
//        if([alertView tag]==505)
//        {
//            SKProduct *SelectedProducts=[_products objectAtIndex:0];
//            [[SendView sharedInstance] buyProduct:SelectedProducts];
//            
//            [self ChangeCredit:5];
//            [self ItsOkShowMeSendOptions];
//        }
//        else if([alertView tag]==510)
//        {
//            SKProduct *SelectedProducts=[_products objectAtIndex:0];
//            [[SendView sharedInstance] buyProduct:SelectedProducts];
//            
//            [self ChangeCredit:10];
//            [self ItsOkShowMeSendOptions];
//        }
    }
    else if(buttonIndex==0)
    {
        if([alertView tag]==205)
        {
            [self EndWait];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"transactionFailed" object:self];
        }
    }
}



#pragma mark for In-App-Purchase


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts)
    {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}


- (BOOL)productPurchased:(NSString *)productIdentifier
{
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product
{
    @try
    {
        if(product)
        {
            NSLog(@"Buying %@...", product.productIdentifier);
            
            SKPayment * payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else
        {
            NSLog(@"Product is null");
        }
    }
    @catch (NSException *Juju)
    {
        NSLog(@"Reporting juju from buyProduct: %@", Juju);
    }
    
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}



- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    SKPaymentTransaction *tran=transaction;
    SKPayment *payment=tran.payment;
    
    
    NSLog(@"payment : %@ || transactionIdentifier: %@ || transactionDate: %@ || productIdentifier: %@ || description: %@", [tran payment], [tran transactionIdentifier], [tran transactionDate], [payment productIdentifier], [payment description]);
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self EndWait];
        NSLog(@"Products: %@", _products);
        SKProduct *Product;
        if([[payment productIdentifier] isEqualToString:@"HCAP001"])
        {
            NSLog(@"5 Set");
            
            Product=[_products objectAtIndex:0];
            
            [self ChangeCredit:5 TransactionIdentifier:[tran transactionIdentifier] Product:Product];
        }
        else if ([[payment productIdentifier] isEqualToString:@"HCAP002"])
        {
            NSLog(@"10 Set");
            Product=[_products objectAtIndex:1];
            [self ChangeCredit:12 TransactionIdentifier:[tran transactionIdentifier] Product:Product];
        }
        
    });
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Transaction Error!!" message:@"Sorry! Failed to complete the transaction. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert setTag:205];
            [alert show];
            
        });
    }
    else
    {
         NSLog(@"User Has Canceled...");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self EndWait];
            
        });
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}
- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
