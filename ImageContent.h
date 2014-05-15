//
//  ImageContent.h
//  Fotohello
//
//  Created by Santanu Das Adhikary on 16/10/13.
//
//

#import <Foundation/Foundation.h>

@interface ImageContent : NSObject {
    NSMutableArray *ImageContentArray,*TrendingImageDetail,*ForProfileImage,*UserProfileImages;
}

@property(nonatomic,retain) NSMutableArray *ImageContentArray,*TrendingImageDetail,*ForProfileImage,*UserProfileImages;
+(ImageContent *)getInstance;
@end
