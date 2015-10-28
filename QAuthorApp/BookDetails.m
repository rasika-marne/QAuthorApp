//
//  BookDetails.m
//  QAuthorApp
//
//  Created by Rasika  on 10/6/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "BookDetails.h"

@implementation BookDetails
@synthesize objectId,bookId,pageNumber,textContent,imageContent;
@synthesize audioContent;

+(BookDetails *)createEmptyObject{
    BookDetails *note=[[BookDetails alloc]initWithClassName:BOOK_DETAILS];
    return note;
}

+(BookDetails *)convertPFObjectToBookDetails:(PFObject *)pobj{
    //  User *user = [User createEmptyUser];
    BookDetails *note=[BookDetails createEmptyObject];
    note.objectId = IS_POPULATED_STRING(pobj.objectId)?pobj.objectId:@"";
    
    note.bookId = IS_POPULATED_STRING([pobj objectForKey:BOOK_ID])?[pobj objectForKey:BOOK_ID]:@"";
    note.textContent = IS_POPULATED_STRING([pobj objectForKey:TEXT_CONTENT])?[pobj objectForKey:TEXT_CONTENT]:@"";
    // note.timestamp =[pobj objectForKey:EVENTS_TIME];
    
    note.pageNumber=[pobj objectForKey:PAGE_NUMBER]?(NSNumber*)[pobj objectForKey:PAGE_NUMBER]:[NSNumber numberWithInt:0];
    
    note.imageContent = [pobj objectForKey:IMAGE_CONTENT];
    note.audioContent = [pobj objectForKey:AUDIO_CONTENT];
    

    
    return note;
    
    
}


-(PFObject*)convertBookDetailsToPFObject{
    PFObject *pObj=[BookDetails createEmptyObject];
    if (self.objectId) {
        [pObj setObjectId:self.objectId];
    }
    // [pObj setObject:IS_POPULATED_STRING(self.createdAt)?self.createdAt:@"" forKey:INBOX_OBJECT_CREATED];
    [pObj setObject:IS_POPULATED_STRING(self.bookId)?self.bookId:@"" forKey:BOOK_ID];
    [pObj setObject:IS_POPULATED_STRING(self.textContent)?self.textContent:@"" forKey:TEXT_CONTENT];
    // [pObj setObject:[NSDate date] forKey:EVENTS_TIME];
    [pObj setObject:self.pageNumber?self.pageNumber:[NSNumber numberWithInt:0] forKey:PAGE_NUMBER];
    
    if (self.imageContent) {
        [pObj setObject:self.imageContent forKey:IMAGE_CONTENT];
    }
    if (self.audioContent) {
        [pObj setObject:self.audioContent forKey:AUDIO_CONTENT];
    }
    
    return pObj;
}

-(void)saveBookDetailsBlock:(AuthorIdResultBlock)block{
    PFObject *pObj=[self convertBookDetailsToPFObject];
    [pObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            block([BookDetails convertPFObjectToBookDetails:pObj],nil);
        }else{
            block(nil,error);
        }
    }];
    
}

-(void)saveBooksInBackground{
    PFObject *pObj=[self convertBookDetailsToPFObject];
    [pObj saveInBackground];
    
}
-(void)fetchBookDetailBlockForBook:(NSString *)bookId1 block1:(arrayResultBlock)block
{
    PFQuery *query=[PFQuery queryWithClassName:BOOK_DETAILS];
    [query whereKey:BOOK_ID equalTo:bookId1];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *results=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects) {
                BookDetails *events=[BookDetails convertPFObjectToBookDetails:obj];
                [results addObject:events];
            }
            block(results,nil);
            
        }else{
            block(nil,error);
        }
    }];
}


@end
