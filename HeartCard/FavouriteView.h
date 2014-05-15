//
//  FavouriteView.h
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface FavouriteView : GlobalViewController< UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    UIGestureRecognizer *TapGesture;
    UIPanGestureRecognizer *PanGesture;
}
@property (nonatomic, assign) BOOL IsNewest;
@property (strong, nonatomic) IBOutlet UIView *ScreenViewFav;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@property (strong, nonatomic) IBOutlet UIScrollView *SVFav;
@end
