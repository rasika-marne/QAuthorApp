//
//  BookLikes.h
//  QAuthorApp
//
//  Created by Rasika  on 10/12/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import "Constant.h"
typedef void (^AuthorIdResultBlock)(id object, NSError *error);
typedef void (^arrayResultBlock)(NSMutableArray *objects, NSError *error);
@interface BookLikes : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *userId;
-(PFObject*)convertBookLikesToPFObject;
+(BookLikes *)convertPFObjectToBookLikes:(PFObject *)pobj;
-(void)saveBookLikesBlock:(AuthorIdResultBlock)block;
+(BookLikes *)createEmptyObject;
//-(void)saveBooksInBackground;
-(void)fetchBookLikesBlock:(arrayResultBlock)block;

@end
