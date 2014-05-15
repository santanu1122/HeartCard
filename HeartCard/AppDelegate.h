//
//  AppDelegate.h
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class CategoryView;
@class Reachability;
@class RateusViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool IsConnetedToInternet;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RateusViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic) bool IsConnetedToInternet;
@property (strong, nonatomic) FBSession *session;
-(void)AddPopupview:(NSString *)textdata;
@end
