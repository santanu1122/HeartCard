//
//  ViaTextMessageView.h
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class GlobalViewController;

@interface ViaTextMessageView : GlobalViewController<UITextFieldDelegate, UIAlertViewDelegate, UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate>
{
    NSString *UniqueCardId, *ParamChooseMsg, *ParamCustomMsg;
    NSData *ParamUploadedImage;
}

@property(nonatomic, retain) NSString *UniqueCardId;
@property(nonatomic, retain) NSString *ParamChooseMsg;
@property(nonatomic, retain) NSString *ParamCustomMsg;
@property(nonatomic, retain) NSString *ParamLastSenderName;
@property(nonatomic, retain) NSData *ParamUploadedImage;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewViaMessage;

@property (strong, nonatomic) IBOutlet UITextField *TxtName;
@property (strong, nonatomic) IBOutlet UITextField *TxtPhone;
@property (strong, nonatomic) IBOutlet UITextField *TxtSelectDate;

@property (strong, nonatomic) IBOutlet UILabel *LblFrom;
@property (strong, nonatomic) IBOutlet UILabel *LblTo;
@property (strong, nonatomic) IBOutlet UILabel *LblErrorMessage;


@property (strong, nonatomic) IBOutlet UIView *UVBackTxt1;
@property (strong, nonatomic) IBOutlet UIView *UVBackTxt2;
@property (strong, nonatomic) IBOutlet UIView *UVBackTxt3;

@end
