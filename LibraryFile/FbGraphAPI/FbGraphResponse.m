//  FbGraphResponse.m
//  iLocalAds
//  Created by Pravin Mahajan on 20/05/15
//  Copyright (c) 2015 Exceptionaire Technologies Pvt. Ltd. All rights reserved.

#import "FbGraphResponse.h"

@implementation FbGraphResponse

@synthesize htmlResponse;
@synthesize imageResponse;

-(void) dealloc {
	
	if (htmlResponse != nil) {
		[htmlResponse release];
	}
	
	if (imageResponse != nil) {
		[imageResponse release];
	}
    [super dealloc];
}

@end
