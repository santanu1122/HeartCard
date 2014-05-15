//
//  StoreLocatorView.h
//  HeartCard
//
//  Created by Iphone_2 on 19/11/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;
@interface StoreLocatorView : GlobalViewController

@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (nonatomic, retain) IBOutlet UIScrollView *SVBack;
@property (strong, nonatomic) IBOutlet UIView *BackView;

@property (nonatomic, retain) NSString *HeaderTitleString;
@end
