//  FbGraphFile.h
//  iLocalAds
//  Created by Pravin Mahajan on 05/05/15.
//  Copyright (c) 2015 Exceptionaire Technologies Pvt. Ltd. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FbGraphFile : NSObject {

	UIImage *uploadImage;
}
@property (nonatomic, retain) UIImage *uploadImage;

- (id)initWithImage:(UIImage *)upload_image;
- (void)appendDataToBody:(NSMutableData *)body;
@end
