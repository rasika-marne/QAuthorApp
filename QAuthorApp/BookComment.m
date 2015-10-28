//
//  BookComment.m
//  QAuthorApp
//
//  Created by Rasika  on 10/12/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "BookComment.h"

@implementation BookComment
@synthesize bookID,userId,userName,comment,objectId;

+(BookComment *)createEmptyObject{
    BookComment *note=[[BookComment alloc]initWithClassName:BOOK_COMMENT];
    return note;
}

+(BookComment *)convertPFObjectToBookComments:(PFObject *)pobj{
    //  User *user = [User createEmptyUser];
    BookComment *note=[BookComment createEmptyObject];
    note.objectId = IS_POPULATED_STRING(pobj.objectId)?pobj.objectId:@"";
    
    note.bookID = IS_POPULATED_STRING([pobj objectForKey:COMMENT_BOOK_ID])?[pobj objectForKey:COMMENT_BOOK_ID]:@"";
    note.comment = IS_POPULATED_STRING([pobj objectForKey:COMMENT])?[pobj objectForKey:COMMENT]:@"";
    // note.timestamp =[pobj objectForKey:EVENTS_TIME];
    note.userId = IS_POPULATED_STRING([pobj objectForKey:COMMENT_USER_ID])?[pobj objectForKey:COMMENT_USER_ID]:@"";
    note.userName = IS_POPULATED_STRING([pobj objectForKey:COMMENT_USER_NAME])?[pobj objectForKey:COMMENT_USER_NAME]:@"";
    
    
    
    return note;
    
    
}


-(PFObject*)convertBookCommentsToPFObject{
    PFObject *pObj=[BookComment createEmptyObject];
    if (self.objectId) {
        [pObj setObjectId:self.objectId];
    }
    // [pObj setObject:IS_POPULATED_STRING(self.createdAt)?self.createdAt:@"" forKey:INBOX_OBJECT_CREATED];
    [pObj setObject:IS_POPULATED_STRING(self.bookID)?self.bookID:@"" forKey:COMMENT_BOOK_ID];
    [pObj setObject:IS_POPULATED_STRING(self.comment)?self.comment:@"" forKey:COMMENT];
    [pObj setObject:IS_POPULATED_STRING(self.userId)?self.userId:@"" forKey:COMMENT_USER_ID];
    [pObj setObject:IS_POPULATED_STRING(self.userName)?self.userName:@"" forKey:COMMENT_USER_NAME];
    // [pObj setObject:[NSDate date] forKey:EVENTS_TIME];
        return pObj;
}

-(void)saveBookCommentsBlock:(AuthorIdResultBlock)block{
    PFObject *pObj=[self convertBookCommentsToPFObject];
    [pObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            block([BookComment convertPFObjectToBookComments:pObj],nil);
        }else{
            block(nil,error);
        }
    }];
    
}

-(void)saveBookCommentInBackground{
    PFObject *pObj=[self convertBookCommentsToPFObject];
    [pObj saveInBackground];
    
}
-(void)fetchBookCommentsBlock:(arrayResultBlock)block
{
    PFQuery *query=[PFQuery queryWithClassName:BOOK_COMMENT];
    [query whereKey:COMMENT_BOOK_ID equalTo:SELECTEDBOOKID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *results=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects) {
                BookComment *events=[BookComment convertPFObjectToBookComments:obj];
                [results addObject:events];
            }
            block(results,nil);
            
        }else{
            block(nil,error);
        }
    }];
}

@end
