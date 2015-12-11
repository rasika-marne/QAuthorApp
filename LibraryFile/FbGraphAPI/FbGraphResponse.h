//  FbGraphResponse.h
//  iLocalAds
//  Created by Pravin Mahajan on 20/05/15.
//  Copyright (c) 2015 Exceptionaire Technologies Pvt. Ltd. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FbGraphResponse : NSObject {

	NSString *htmlResponse;
	UIImage *imageResponse;
	
}

@property (nonatomic, retain) NSString *htmlResponse;
@property (nonatomic, retain) UIImage *imageResponse;

@end
