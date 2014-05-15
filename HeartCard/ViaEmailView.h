//
//  ViaEmailView.h
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface ViaEmailView : GlobalViewController<UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    NSString *UniqueCardId, *ParamChooseMsg, *ParamCustomMsg;
    NSData *ParamUploadedImage;
}

@property(nonatomic, retain) NSString *UniqueCardId;
@property(nonatomic, retain) NSString *ParamChooseMsg;
@property(nonatomic, retain) NSString *ParamCustomMsg;
@property(nonatomic, retain) NSString *ParamLastSenderName;
@property(nonatomic, retain) NSString *ParamLastSenderEmail;
@property(nonatomic, retain) NSData *ParamUploadedImage;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewEmail;

@property (strong, nonatomic) IBOutlet UIScrollView *SVBackView;
@property (strong, nonatomic) IBOutlet UILabel *LblFrom;
@property (strong, nonatomic) IBOutlet UILabel *LblTo;
@property (strong, nonatomic) IBOutlet UILabel *LblErrorEmail;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;


@property (strong, nonatomic) IBOutlet UIView *TxtBackView1;
@property (strong, nonatomic) IBOutlet UIView *TxtBackView2;
@property (strong, nonatomic) IBOutlet UIView *TxtBackView3;
@property (strong, nonatomic) IBOutlet UIView *TxtBackView4;
@property (strong, nonatomic) IBOutlet UIView *TxtBackView5;

@property (strong, nonatomic) IBOutlet UITextField *TxtYourName;
@property (strong, nonatomic) IBOutlet UITextField *TxtYourEmail;
@property (strong, nonatomic) IBOutlet UITextField *TxtTheirName;
@property (strong, nonatomic) IBOutlet UITextField *TxtTheirEmail;
@property (strong, nonatomic) IBOutlet UITextField *TxtSelectDate;


@end
