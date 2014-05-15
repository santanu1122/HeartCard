//
//  cardsView.h
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;


@interface cardsView : GlobalViewController<UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate,UIAlertViewDelegate>
{
   @public NSString *CardName, *CardId;
    UIGestureRecognizer *TapGesture;
    UIPanGestureRecognizer *PanGesture, *OpenPanGesture, *ClosePanGesture;
}

@property (nonatomic, retain) NSString *CardName;
@property (nonatomic, retain) NSString *CardId;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewCards;

@property (strong, nonatomic) IBOutlet UIScrollView *SVCards;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;

@end
