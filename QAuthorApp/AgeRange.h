//
//  AgeRange.h
//  QAuthorApp
//
//  Created by Rasika  on 10/7/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import "Constant.h"
typedef void (^AuthorIdResultBlock)(id object, NSError *error);
typedef void (^arrayResultBlock)(NSMutableArray *objects, NSError *error);
@interface AgeRange : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSNumber *ageTo;
@property (nonatomic, strong) NSNumber *ageFrom;
-(PFObject*)convertAgeRangeToPFObject;
+(AgeRange *)convertPFObjectToAgeRange:(PFObject *)pobj;
+(AgeRange *)createEmptyObject;
-(void)fetchAgeRangeBlock:(arrayResultBlock)block;

@end
