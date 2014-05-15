//
//  SendView.h
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <StoreKit/StoreKit.h>


UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@class GlobalViewController;

@interface SendView : GlobalViewController<UIAlertViewDelegate>
{
    NSString *UniqueCardId, *ParamChooseMsg, *ParamCustomMsg;
    NSData *ParamUploadedImage;
    NSString *FBAccessToken, *FBUID;
}

+ (SendView *)sharedInstance;
-(void)EndWait;

@property(nonatomic, retain) NSString *UniqueCardId;
@property(nonatomic, retain) NSString *ParamChooseMsg;
@property(nonatomic, retain) NSString *ParamCustomMsg;
@property(nonatomic, retain) NSData *ParamUploadedImage;

@property (strong, nonatomic) IBOutlet UILabel *LblErrorSend;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;

@property (nonatomic,retain) ACAccountStore *accountStore;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewSend;

@property (strong, nonatomic) IBOutlet UIButton *BtnTwitter;
@property (strong, nonatomic) IBOutlet UIButton *BtnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *BtnEmail;
@property (strong, nonatomic) IBOutlet UIButton *BtnTextMessage;

- (IBAction)BtnFBTouched:(id)sender;
- (IBAction)BtnTwitTouched:(id)sender;
- (IBAction)BtnEmailTouched:(id)sender;
- (IBAction)BtnMessageTouched:(id)sender;


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

- (void)restoreCompletedTransactions;

@end
