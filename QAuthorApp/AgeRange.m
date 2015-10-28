//
//  AgeRange.m
//  QAuthorApp
//
//  Created by Rasika  on 10/7/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "AgeRange.h"

@implementation AgeRange
@synthesize ageFrom,ageTo,objectId;
+(AgeRange *)createEmptyObject{
    AgeRange *note=[[AgeRange alloc]initWithClassName:AGE_RANGE];
    return note;
}

+(AgeRange *)convertPFObjectToAgeRange:(PFObject *)pobj{
    //  User *user = [User createEmptyUser];
    AgeRange *note=[AgeRange createEmptyObject];
    note.objectId = IS_POPULATED_STRING(pobj.objectId)?pobj.objectId:@"";
    
    
    note.ageFrom=[pobj objectForKey:AGE_FROM]?(NSNumber*)[pobj objectForKey:AGE_FROM]:[NSNumber numberWithInt:0];
    note.ageTo=[pobj objectForKey:AGE_TO]?(NSNumber*)[pobj objectForKey:AGE_TO]:[NSNumber numberWithInt:0];
    
    
    return note;
    
    
}


-(PFObject*)convertAgeRangeToPFObject{
    PFObject *pObj=[Book createEmptyObject];
    if (self.objectId) {
        [pObj setObjectId:self.objectId];
    }
    // [pObj setObject:IS_POPULATED_STRING(self.createdAt)?self.createdAt:@"" forKey:INBOX_OBJECT_CREATED];
        [pObj setObject:self.ageFrom?self.ageFrom:[NSNumber numberWithInt:0] forKey:AGE_FROM];
        [pObj setObject:self.ageTo?self.ageTo:[NSNumber numberWithInt:0] forKey:AGE_TO];
        return pObj;
}

-(void)fetchAgeRangeBlock:(arrayResultBlock)block
{
    PFQuery *query=[PFQuery queryWithClassName:AGE_RANGE];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *results=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects) {
                AgeRange *events=[AgeRange convertPFObjectToAgeRange:obj];
                [results addObject:events];
            }
            block(results,nil);
            
        }else{
            block(nil,error);
        }
    }];
}
@end
