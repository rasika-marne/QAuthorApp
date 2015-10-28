//
//  User.m
//  QAuthorApp
//
//  Created by Rasika  on 9/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "User.h"

@implementation User
@synthesize username;
@synthesize password,email,age,status,profilePic;
@synthesize favoriteAuthor1,favoriteAuthor2,favoriteAuthor3;
@synthesize language,nwAuthor1,nwAuthor2,facebookId;
@synthesize city,country,objectId,firstName,lastName,role;
+(User *)createEmptyUser{
    User *user=[[User alloc]initWithClassName:USER];
    return user;
}

+(User *)convertPFObjectToUser:(PFObject *)userObject forNote:(BOOL)isForNote{
    User *user=[User createEmptyUser];
    
    user.objectId = IS_POPULATED_STRING(userObject.objectId)?userObject.objectId:@"";
    user.username = IS_POPULATED_STRING([userObject objectForKey:USERNAME])?[userObject objectForKey:USERNAME]:@"";
    user.email = IS_POPULATED_STRING([userObject objectForKey:EMAIL_ID])?[userObject objectForKey:EMAIL_ID]:@"";
    user.password = IS_POPULATED_STRING([userObject objectForKey:PASSWORD])?[userObject objectForKey:PASSWORD]:@"";
    user.city = IS_POPULATED_STRING([userObject objectForKey:CITY])?[userObject objectForKey:CITY]:@"";
    user.profilePic = [userObject objectForKey:PROFILE_PIC];
    
    user.language = IS_POPULATED_STRING([userObject objectForKey:LANGUAGE])?[userObject objectForKey:LANGUAGE]:@"";
    user.country = IS_POPULATED_STRING([userObject objectForKey:COUNTRY])?[userObject objectForKey:COUNTRY]:@"";
    user.status = IS_POPULATED_STRING([userObject objectForKey:STATUS])?[userObject objectForKey:STATUS]:@"";
    user.facebookId = IS_POPULATED_STRING([userObject objectForKey:FACEBOOK_ID])?[userObject objectForKey:FACEBOOK_ID]:@"";
    user.role = IS_POPULATED_STRING([userObject objectForKey:ROLE])?[userObject objectForKey:ROLE]:@"";
    user.favoriteAuthor1 = IS_POPULATED_STRING([userObject objectForKey:FAVORITE_AUTHOR1])?[userObject objectForKey:FAVORITE_AUTHOR1]:@"";
    user.favoriteAuthor2 = IS_POPULATED_STRING([userObject objectForKey:FAVORITE_AUTHOR2])?[userObject objectForKey:FAVORITE_AUTHOR2]:@"";
    user.favoriteAuthor3 = IS_POPULATED_STRING([userObject objectForKey:FAVORITE_AUTHOR3])?[userObject objectForKey:FAVORITE_AUTHOR3]:@"";
    user.nwAuthor1 = IS_POPULATED_STRING([userObject objectForKey:NEW_AUTHOR1])?[userObject objectForKey:NEW_AUTHOR1]:@"";
    user.firstName = IS_POPULATED_STRING([userObject objectForKey:FIRST_NAME])?[userObject objectForKey:FIRST_NAME]:@"";
    user.lastName = IS_POPULATED_STRING([userObject objectForKey:LAST_NAME])?[userObject objectForKey:LAST_NAME]:@"";
     user.nwAuthor2 = IS_POPULATED_STRING([userObject objectForKey:NEW_AUTHOR2])?[userObject objectForKey:NEW_AUTHOR2]:@"";
    user.age=[userObject objectForKey:AGE]?(NSNumber*)[userObject objectForKey:AGE]:[NSNumber numberWithInt:0];

    
    
    
    return user;
}


-(void)updateUserblock:(AuthorIdResultBlock)block{
    PFUser *pfUser=[self  convertUserToPFUser];
    [pfUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            block([User convertPFObjectToUser:pfUser forNote:NO],error);
        }
    }];
}

-(PFUser*)convertUserToPFUser
{
    PFUser *user=[PFUser user];
    if (self.objectId) {
        [user setObjectId:self.objectId];
    }
    
    [user setUsername:IS_POPULATED_STRING(self.email)?self.email:@""];
    [user setEmail:IS_POPULATED_STRING(self.email)?self.email:@""];
    [user setPassword:IS_POPULATED_STRING(self.password)?self.password:@""];
    
    
    [user setObject:IS_POPULATED_STRING(self.city)?self.city:@"" forKey:CITY];
    [user setObject:IS_POPULATED_STRING(self.country)?self.country:@"" forKey:COUNTRY];
    [user setObject:IS_POPULATED_STRING(self.language)?self.language:@"" forKey:LANGUAGE];
    [user setObject:IS_POPULATED_STRING(self.status)?self.status:@"" forKey:STATUS];
    [user setObject:IS_POPULATED_STRING(self.facebookId)?self.facebookId:@"" forKey:FACEBOOK_ID];
    [user setObject:IS_POPULATED_STRING(self.role)?self.role:@"" forKey:ROLE];
    if (self.profilePic) {
        [user setObject:self.profilePic forKey:PROFILE_PIC];
    }
    [user setObject:IS_POPULATED_STRING(self.favoriteAuthor1)?self.favoriteAuthor1:@"" forKey:FAVORITE_AUTHOR1];
    [user setObject:IS_POPULATED_STRING(self.favoriteAuthor2)?self.favoriteAuthor2:@"" forKey:FAVORITE_AUTHOR2];
    [user setObject:IS_POPULATED_STRING(self.favoriteAuthor3)?self.favoriteAuthor3:@"" forKey:FAVORITE_AUTHOR3];
     [user setObject:IS_POPULATED_STRING(self.firstName)?self.firstName:@"" forKey:FIRST_NAME];
     [user setObject:IS_POPULATED_STRING(self.lastName)?self.lastName:@"" forKey:LAST_NAME];
    [user setObject:IS_POPULATED_STRING(self.nwAuthor1)?self.nwAuthor1: @"" forKey:NEW_AUTHOR1];
    [user setObject:IS_POPULATED_STRING(self.nwAuthor2)?self.nwAuthor2:@"" forKey:NEW_AUTHOR2];
    [user setObject:self.age?self.age:[NSNumber numberWithInt:0] forKey:AGE];
    //  [user setObject:IS_POPULATED_STRING(self.city)?self.city:@"" forKey:CITY];
    //  [user setObject:IS_POPULATED_STRING(self.state)?self.state:@"" forKey:STATE];
    //  [user setObject:IS_POPULATED_STRING(self.country)?self.country:@"" forKey:COUNTRY];
    //  [user setObject:IS_POPULATED_STRING(self.zip)?self.zip:@"" forKey:ZIP];
    
    // [user setObject:IS_POPULATED_STRING(self.teachingAt)?self.teachingAt:@"" forKey:TEACHING_AT];
    //  [user setObject:IS_POPULATED_STRING(self.exTeacherAt)?self.exTeacherAt:@"" forKey:EXTEACHER_AT];
    
    
    return user;
}

-(void)signUpBlock:(AuthorIdResultBlock)block
{
    PFUser *user=[self convertUserToPFUser];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // [self.delegate onSuccess:SIGN_UP forModelClass:USER_M response:[User convertPFObjectToUser:user forNote:NO]];
            block([User convertPFObjectToUser:user forNote:NO],nil);
        }
        else {
            // [self.delegate onFailure:SIGN_UP forModelClass:USER_M error:error];
            block(nil,error);
        }
    }];
    
}

-(void)loginblock:(AuthorIdResultBlock)block
{
    [PFUser logInWithUsernameInBackground:self.email password:self.password block:^(PFUser *user, NSError *error) {
        if (!error) {
            block([User convertPFObjectToUser:user forNote:NO],nil);
        }
        else {
            block(nil,error);
        }
    }];
    
}

+(void)logout{
    //PFUser *user;
   // APP_DELEGATE.loggedInUser = nil;
   // [APP_DELEGATE clearLoggedInUserDetail];
}



-(BOOL)isEqual:(User*)object{
    
    return [self.objectId isEqualToString:object.objectId];
}

#pragma mark - Fetch User For Userid


+(void)fetchUser:(NSString*)userId block:(AuthorIdResultBlock)block{
    PFQuery *query=[PFUser query];
    [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
        if (!error) {
            User *user=[User convertPFObjectToUser:(PFUser*)object forNote:NO];
            block(user,error);
        }else{
            block(nil,error);
        }
        
    }];
    
    
}
-(void)refreshObjectblock:(AuthorIdResultBlock)block{
    PFUser *pfUser=[self convertUserToPFUser];
    [pfUser refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error && object) {
            block([User convertPFObjectToUser:(PFUser*)object forNote:NO],nil);
        }else{
            block(nil,error);
        }
    }];
}



@end
