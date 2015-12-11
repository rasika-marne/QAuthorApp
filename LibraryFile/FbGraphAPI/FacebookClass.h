//  FacebookClass.h
//  iLocalAds
//  Created by Pravin Mahajan on 05/05/15.
//  Copyright (c) 2015 Exceptionaire Technologies Pvt. Ltd. All rights reserved.

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@class FBPostViewController;

@interface FacebookClass : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate> {
    
	Facebook * _facebook;
	NSString * _token;
	NSString *companyNameString;
	NSString *adsDescriptionString;
    NSString *appSourceLinkString;
}
@property(nonatomic,retain)FBPostViewController *obj;
@property(nonatomic,retain)Facebook * _facebook;
@property(nonatomic,retain)NSString * _token;
@property(nonatomic,retain)NSString *companyNameString;
@property(nonatomic,retain)NSString *adsDescriptionString;
@property(nonatomic,retain)NSString *appSourceLinkString;

+ (FacebookClass *)getObject;
- (void) facebookAuth;
- (void) facebookLogout;
- (void) facebookPublicApi;
- (void) facebookStreamPublish;


@end
