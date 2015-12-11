//  FbGraph.h
//  iLocalAds
//  Created by Pravin Mahajan on 05/05/15.
//  Copyright (c) 2015 Exceptionaire Technologies Pvt. Ltd. All rights reserved.

#import <Foundation/Foundation.h>
#import "FbGraphResponse.h"
#import <UIKit/UIKit.h>

@interface FbGraph : NSObject <UIWebViewDelegate> {

	NSString *facebookClientID;
	NSString *redirectUri;
	NSString *accessToken;
	UIView *fbConnectView;
	UIWebView *webView;
	UIButton *closeButton;
    UILabel *titleLabel;
	id callbackObject;
	SEL callbackSelector;
    UIActivityIndicatorView *activity;
    
}

@property (nonatomic, retain) NSString *facebookClientID;
@property (nonatomic, retain) NSString *redirectUri;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIView *fbConnectView;  ;

@property (assign) id callbackObject;
@property (assign) SEL callbackSelector;

- (id)initWithFbClientID:fbcid;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions andSuperView:(UIView *)super_view;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector andExtendedPermissions:(NSString *)extended_permissions;
- (FbGraphResponse *)doGraphGet:(NSString *)action withGetVars:(NSDictionary *)get_vars;
- (FbGraphResponse *)doGraphGetWithUrlString:(NSString *)url_string;
- (FbGraphResponse *)doGraphPost:(NSString *)action withPostVars:(NSDictionary *)post_vars;

@end
