//
//  Book.h
//  QAuthorApp
//
//  Created by Rasika  on 10/1/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import "Constant.h"
#import "User.h"
@class User;
typedef void (^AuthorIdResultBlock)(id object, NSError *error);
typedef void (^arrayResultBlock)(NSMutableArray *objects, NSError *error);
@interface Book : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *shortDesc;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *eCommerceUrl;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) PFUser *authorId;

@property (nonatomic, strong) PFFile *coverPic;
@property (nonatomic, strong) PFFile *pdfFile;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *ageFrom;
@property (nonatomic, strong) NSNumber *ageTo;
@property (nonatomic, strong) NSNumber *noOfLikes;
@property (nonatomic, strong) NSNumber *noOfComments;


-(PFObject*)convertBooksToPFObject;
+(Book *)convertPFObjectToBooks:(PFObject *)pobj;
-(void)saveBooksBlock:(AuthorIdResultBlock)block;
+(Book *)createEmptyObject;
-(void)saveBooksInBackground;
-(void)fetchBookBlock:(arrayResultBlock)block;
@end
