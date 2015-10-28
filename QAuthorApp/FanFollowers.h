//
//  FanFollowers.h
//  QAuthorApp
//
//  Created by Rasika  on 10/19/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import "Constant.h"
typedef void (^AuthorIdResultBlock)(id object, NSError *error);
typedef void (^arrayResultBlock)(NSMutableArray *objects, NSError *error);
@interface FanFollowers : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *followers;
@property (nonatomic, strong) NSString *userId;
-(PFObject*)convertFansToPFObject;
+(FanFollowers *)convertPFObjectToFans:(PFObject *)pobj;
-(void)saveFansBlock:(AuthorIdResultBlock)block;
+(FanFollowers *)createEmptyObject;
//-(void)saveBooksInBackground;
-(void)fetchFansBlock:(arrayResultBlock)block;



@end
