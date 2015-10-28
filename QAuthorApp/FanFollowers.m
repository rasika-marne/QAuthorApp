//
//  FanFollowers.m
//  QAuthorApp
//
//  Created by Rasika  on 10/19/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "FanFollowers.h"

@implementation FanFollowers
@synthesize followers,userId,objectId;
+(FanFollowers *)createEmptyObject{
    FanFollowers *note=[[FanFollowers alloc]initWithClassName:FAN_FOLLOWERS];
    return note;
}

+(FanFollowers *)convertPFObjectToFans:(PFObject *)pobj{
    //  User *user = [User createEmptyUser];
    FanFollowers *note=[FanFollowers createEmptyObject];
    note.objectId = IS_POPULATED_STRING(pobj.objectId)?pobj.objectId:@"";
    
    note.followers = IS_POPULATED_STRING([pobj objectForKey:FOLLOWERS])?[pobj objectForKey:FOLLOWERS]:@"";
    note.userId = IS_POPULATED_STRING([pobj objectForKey:FAN_USER_ID])?[pobj objectForKey:FAN_USER_ID]:@"";
    // note.timestamp =[pobj objectForKey:EVENTS_TIME];
    
    
    return note;
    
    
}


-(PFObject*)convertFansToPFObject{
    PFObject *pObj=[FanFollowers createEmptyObject];
    if (self.objectId) {
        [pObj setObjectId:self.objectId];
    }
    // [pObj setObject:IS_POPULATED_STRING(self.createdAt)?self.createdAt:@"" forKey:INBOX_OBJECT_CREATED];
    [pObj setObject:IS_POPULATED_STRING(self.followers)?self.followers:@"" forKey:FOLLOWERS];
    // [pObj setObject:IS_POPULATED_STRING(self.comment)?self.comment:@"" forKey:COMMENT];
    [pObj setObject:IS_POPULATED_STRING(self.userId)?self.userId:@"" forKey:FAN_USER_ID];
    // [pObj setObject:IS_POPULATED_STRING(self.userName)?self.userName:@"" forKey:COMMENT_USER_NAME];
    // [pObj setObject:[NSDate date] forKey:EVENTS_TIME];
    return pObj;
}

-(void)saveFansBlock:(AuthorIdResultBlock)block{
    PFObject *pObj=[self convertFansToPFObject];
    [pObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            block([FanFollowers convertPFObjectToFans:pObj],nil);
        }else{
            block(nil,error);
        }
    }];
    
}


-(void)fetchFansBlock:(arrayResultBlock)block
{
    PFQuery *query=[PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *results=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects) {
                FanFollowers *events=[FanFollowers convertPFObjectToFans:obj];
                [results addObject:events];
            }
            block(results,nil);
            
        }else{
            block(nil,error);
        }
    }];
}


@end
