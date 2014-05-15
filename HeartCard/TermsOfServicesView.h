//
//  TermsOfServicesView.h
//  HeartCard
//
//  Created by Iphone_2 on 15/11/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface TermsOfServicesView : GlobalViewController

@property (strong, nonatomic) IBOutlet UIView *ScreenView;
@property (nonatomic, retain) IBOutlet UIScrollView *SVBack;
@property (strong, nonatomic) IBOutlet UIView *BackView;

@property (nonatomic, retain) NSString *HeaderTitleString;

@end
