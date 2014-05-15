//
//  MoreOptionDetails.h
//  HeartCard
//
//  Created by Iphone_2 on 10/09/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;


@interface MoreOptionDetails : GlobalViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *ScreenViewCategory;

@property(nonatomic, retain)GlobalMethod *ParamMethod;

@property (strong, nonatomic) IBOutlet UITextView *TVDescription;
@property (strong, nonatomic) IBOutlet UIView *BackView;
@end
