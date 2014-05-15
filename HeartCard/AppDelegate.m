//
//  AppDelegate.m
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//


#import "AppDelegate.h"
#import "CategoryView.h"
#import "Reachability.h"
#import "noConnection.h"
#import "GlobalMethod.h"
#import "RateusViewController.h"

@implementation AppDelegate

@synthesize navigationController, IsConnetedToInternet;
@synthesize session = _session;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     IsConnetedToInternet=true;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RateusViewController alloc] initWithNibName:@"RateusViewController" bundle:nil];
    
    navigationController = [[UINavigationController alloc] init];
    [navigationController pushViewController:self.viewController animated:NO];
    
    //self.window.rootViewController = self.viewController;
    
    [navigationController setHidesBottomBarWhenPushed:YES];
    [[navigationController navigationBar] setHidden:YES];
    [[self window] setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"< "withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"deviceToken----%@",token);
}
-(void)AddPopupview:(NSString *)textdata {
    
    UIView *MyView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 310, 100)];
    [MyView setBackgroundColor:[UIColor whiteColor]];
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 10)];
    [Label setText:textdata];
    [MyView addSubview:Label];
    [self.window addSubview:MyView];
    [self.window bringSubviewToFront:MyView];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.session closeAndClearTokenInformation];
    [self.session close];
    self.session=NULL;
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        [cookies deleteCookie:cookie];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark reachability code starts here

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            IsConnetedToInternet=false;
            
            noConnection *noConnetionNib;
            
            noConnetionNib=(IsIphone5)?[[noConnection alloc] initWithNibName:@"noConnectionBig" bundle:nil]:[[noConnection alloc] initWithNibName:@"noConnection" bundle:nil];
            [[self navigationController] presentViewController:noConnetionNib animated:YES completion:^{
                
            }];
            
            break;
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"Wifi");
            if(!IsConnetedToInternet)
            {
                [[self navigationController] dismissViewControllerAnimated:YES completion:Nil];
            }
            IsConnetedToInternet=true;
            break;
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"3g");
            if(!IsConnetedToInternet)
            {
                [[self navigationController] dismissViewControllerAnimated:YES completion:Nil];
            }
            IsConnetedToInternet=true;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            //NSLog(@"no internet");
            break;
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"wifi");
            break;
        }
        case ReachableViaWWAN:
        {
            // NSLog(@"3g");
            break;
        }
    }
}

#pragma mark reachability code ends here




@end
