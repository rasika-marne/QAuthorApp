//
//  User.h
//  QAuthorApp
//
//  Created by Rasika  on 9/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h> 
#import "Constant.h"
typedef void (^AuthorIdResultBlock)(id object, NSError *error);

@interface User : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) PFFile *profilePic;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *favoriteAuthor1;
@property (nonatomic, strong) NSString *favoriteAuthor2;
@property (nonatomic, strong) NSString *favoriteAuthor3;
@property (nonatomic, strong) NSString *nwAuthor1;
@property (nonatomic, strong) NSString *nwAuthor2;
+(User *)createEmptyUser;
-(PFUser*)convertUserToPFUser;
-(void)updateUserblock:(AuthorIdResultBlock)block;

+(User *)convertPFObjectToUser:(PFObject *)userObject forNote:(BOOL)isForNote;
-(void)signUpBlock:(AuthorIdResultBlock)block;
-(void)loginblock:(AuthorIdResultBlock)block;

+(void)fetchUser:(NSString*)userId block:(AuthorIdResultBlock)block;
+(void)logout;
@end
