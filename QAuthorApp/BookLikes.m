//
//  BookLikes.m
//  QAuthorApp
//
//  Created by Rasika  on 10/12/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "BookLikes.h"

@implementation BookLikes
@synthesize bookId,objectId,userId;
+(BookLikes *)createEmptyObject{
    BookLikes *note=[[BookLikes alloc]initWithClassName:BOOK_LIKES];
    return note;
}

+(BookLikes *)convertPFObjectToBookLikes:(PFObject *)pobj{
    //  User *user = [User createEmptyUser];
    BookLikes *note=[BookLikes createEmptyObject];
    note.objectId = IS_POPULATED_STRING(pobj.objectId)?pobj.objectId:@"";
    
    note.bookId = IS_POPULATED_STRING([pobj objectForKey:LIKE_BOOK_ID])?[pobj objectForKey:LIKE_BOOK_ID]:@"";
    note.userId = IS_POPULATED_STRING([pobj objectForKey:LIKE_USER_ID])?[pobj objectForKey:LIKE_USER_ID]:@"";
    // note.timestamp =[pobj objectForKey:EVENTS_TIME];
    
    
    return note;
    
    
}


-(PFObject*)convertBookLikesToPFObject{
    PFObject *pObj=[BookLikes createEmptyObject];
    if (self.objectId) {
        [pObj setObjectId:self.objectId];
    }
    // [pObj setObject:IS_POPULATED_STRING(self.createdAt)?self.createdAt:@"" forKey:INBOX_OBJECT_CREATED];
    [pObj setObject:IS_POPULATED_STRING(self.bookId)?self.bookId:@"" forKey:LIKE_BOOK_ID];
   // [pObj setObject:IS_POPULATED_STRING(self.comment)?self.comment:@"" forKey:COMMENT];
    [pObj setObject:IS_POPULATED_STRING(self.userId)?self.userId:@"" forKey:COMMENT_USER_ID];
   // [pObj setObject:IS_POPULATED_STRING(self.userName)?self.userName:@"" forKey:COMMENT_USER_NAME];
    // [pObj setObject:[NSDate date] forKey:EVENTS_TIME];
    return pObj;
}

-(void)saveBookLikesBlock:(AuthorIdResultBlock)block{
    PFObject *pObj=[self convertBookLikesToPFObject];
    [pObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            block([BookLikes convertPFObjectToBookLikes:pObj],nil);
        }else{
            block(nil,error);
        }
    }];
    
}


-(void)fetchBookLikesBlock:(arrayResultBlock)block
{
    PFQuery *query=[PFQuery queryWithClassName:BOOK_LIKES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *results=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects) {
                BookLikes *events=[BookLikes convertPFObjectToBookLikes:obj];
                [results addObject:events];
            }
            block(results,nil);
            
        }else{
            block(nil,error);
        }
    }];
}

@end
