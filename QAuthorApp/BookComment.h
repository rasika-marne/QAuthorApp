//
//  BookComment.h
//  QAuthorApp
//
//  Created by Rasika  on 10/12/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import "Constant.h"
typedef void (^AuthorIdResultBlock)(id object, NSError *error);
typedef void (^arrayResultBlock)(NSMutableArray *objects, NSError *error);
@interface BookComment : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *bookID;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *userName;
-(PFObject*)convertBookCommentsToPFObject;
+(BookComment *)convertPFObjectToBookComments:(PFObject *)pobj;
-(void)saveBookCommentsBlock:(AuthorIdResultBlock)block;
+(BookComment *)createEmptyObject;
//-(void)saveBooksInBackground;
-(void)fetchBookCommentBlock:(arrayResultBlock)block;
@end
