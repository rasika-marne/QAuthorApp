//  FacebookClass.m
//  iLocalAds
//  Created by Pravin Mahajan on 05/05/15.
//  Copyright (c) 2015 Exceptionaire Technologies Pvt. Ltd. All rights reserved.


#import "FacebookClass.h"
#import "FBConnect.h"

// User Id for public API
static NSString* kTestUser =@"";


@implementation FacebookClass

@synthesize _facebook,_token,companyNameString,adsDescriptionString,appSourceLinkString;

+ (FacebookClass *)getObject {
    
    // the instance of this class is stored here
    static FacebookClass *myInstance = nil;
	
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
		
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

//////////////////////////////////////////////////////////////////////////////////////////
// Private helper function

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
    
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];  
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	}
	
	return str;
}
// Method to check user authentication is successful or not also get access token
- (void) facebookAuth {
    
    if (_facebook.accessToken) {
	}
    else {
	}
	_token = [_facebook.accessToken retain];
	
}
// Method for logout
- (void) facebookLogout {
    
    [_facebook logout:self];
}

//Get the Public details of User like Name and ID	

- (void) facebookPublicApi {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									[NSString stringWithFormat:@"SELECT uid,name FROM user WHERE uid=%@", kTestUser],
									@"query",
									nil];
	
	[_facebook requestWithMethodName: @"fql.query" 
						   andParams: params
					   andHttpMethod: @"POST" 
						 andDelegate: self];   
}

//Method to publish on facebook

- (void) facebookStreamPublish {
    
	/*SBJSON *jsonWriter = [[SBJSON new] autorelease];
	NSMutableDictionary* params;
    
	NSString * imgScrLink = @"http://ilocalads.com/companylogo/1358317424.jpg";
    NSString * appScrLink = @"http://ilocalads.com/";
    NSString * mediaType = @"image";
    
    NSDictionary* mediaDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     mediaType, @"type",
                                     imgScrLink, @"src",
                                     appScrLink, @"href", nil];
    
    //		NSString *mediaStr = [jsonWriter stringWithObject:mediaDictionary];
    
    NSArray* mediaLinks = [NSArray arrayWithObjects:mediaDictionary,nil];
    
    //		NSString *mediaLinksStr = [jsonWriter stringWithObject:mediaLinks];
    
    //---------------------------------------------------------------------------
	            
        //here if you want put your application online link adress as a object for key href
        NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               @"Link",@"text",appSourceLinkString,@"href", nil], nil];
        
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
		//---------------------------------------------------------------------------
        
        //Here if you want put quesitonDescription object for description key.
       //http://ilocalads.com/companylogo/1358317424.jpg
    NSDictionary* attachment;
    attachment= [NSDictionary dictionaryWithObjectsAndKeys:companyNameString ,@"name",adsDescriptionString ,@"description",appSourceLinkString,@"href",mediaLinks,@"media",nil];
		NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
		params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  FbClientID, @"api_key",
                  @"Share iLocalAds",  @"user_message_prompt",
                  actionLinksStr, @"action_links",
                  attachmentStr, @"attachment",
                  nil];
	
	[_facebook dialog: @"stream.publish" andParams: params andDelegate:self];*/
}

//////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

- (void)dialogCompleteWithUrl:(NSURL *)url {
    
	NSString *post_id = [self getStringFromUrl:[url absoluteString] needle:@"post_id="];
	
	if (post_id.length > 0) {
        
	}
    else {
        
	}
}
@end
