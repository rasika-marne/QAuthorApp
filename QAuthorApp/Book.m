//
//  Book.m
//  QAuthorApp
//
//  Created by Rasika  on 10/1/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "Book.h"

@implementation Book
@synthesize objectId,title,genre,authorId,status,shortDesc,type;
@synthesize coverPic,noOfComments,noOfLikes,ageFrom,ageTo,pdfFile,eCommerceUrl,price,authorName;

+(Book *)createEmptyObject{
    Book *note=[[Book alloc]initWithClassName:BOOK];
    return note;
}

+(Book *)convertPFObjectToBooks:(PFObject *)pobj{
    //  User *user = [User createEmptyUser];
    Book *note=[Book createEmptyObject];
    note.objectId = pobj.objectId;

    note.title = IS_POPULATED_STRING([pobj objectForKey:TITLE])?[pobj objectForKey:TITLE]:@"";
    note.genre = IS_POPULATED_STRING([pobj objectForKey:GENRE])?[pobj objectForKey:GENRE]:@"";
    note.type = IS_POPULATED_STRING([pobj objectForKey:TYPE])?[pobj objectForKey:TYPE]:@"";
    note.authorName = IS_POPULATED_STRING([pobj objectForKey:AUTHOR_NAME])?[pobj objectForKey:AUTHOR_NAME]:@"";
    note.eCommerceUrl = IS_POPULATED_STRING([pobj objectForKey:ECOMMERCE_URL])?[pobj objectForKey:ECOMMERCE_URL]:@"";
    note.price = IS_POPULATED_STRING([pobj objectForKey:PRICE])?[pobj objectForKey:PRICE]:@"";

    note.shortDesc = IS_POPULATED_STRING([pobj objectForKey:SHORT_DESC])?[pobj objectForKey:SHORT_DESC]:@"";

   // note.timestamp =[pobj objectForKey:EVENTS_TIME];
    
    note.authorId = [pobj objectForKey:AUTHOR_ID];
    note.status = IS_POPULATED_STRING([pobj objectForKey:STATUS])?[pobj objectForKey:STATUS]:@"";
    note.ageFrom=[pobj objectForKey:AGE_FROM]?(NSNumber*)[pobj objectForKey:AGE_FROM]:[NSNumber numberWithInt:0];
    note.ageTo=[pobj objectForKey:AGE_TO]?(NSNumber*)[pobj objectForKey:AGE_TO]:[NSNumber numberWithInt:0];
    note.noOfLikes=[pobj objectForKey:NUMBER_OF_LIKES]?(NSNumber*)[pobj objectForKey:NUMBER_OF_LIKES]:[NSNumber numberWithInt:0];
    note.noOfComments=[pobj objectForKey:NUMBER_OF_COMMENTS]?(NSNumber*)[pobj objectForKey:NUMBER_OF_COMMENTS]:[NSNumber numberWithInt:0];
    
    note.coverPic = [pobj objectForKey:COVER_PAGE];
    note.pdfFile = [pobj objectForKey:PDF_FILE];


    return note;
    
    
}


-(PFObject*)convertBooksToPFObject{
    PFObject *pObj=[Book createEmptyObject];
    if (self.objectId) {
        [pObj setObjectId:self.objectId];
    }
    // [pObj setObject:IS_POPULATED_STRING(self.createdAt)?self.createdAt:@"" forKey:INBOX_OBJECT_CREATED];
    [pObj setObject:IS_POPULATED_STRING(self.title)?self.title:@"" forKey:TITLE];
    [pObj setObject:IS_POPULATED_STRING(self.genre)?self.genre:@"" forKey:GENRE];
    [pObj setObject:IS_POPULATED_STRING(self.type)?self.type:@"" forKey:TYPE];
    [pObj setObject:IS_POPULATED_STRING(self.price)?self.price:@"" forKey:PRICE];
    [pObj setObject:IS_POPULATED_STRING(self.eCommerceUrl)?self.eCommerceUrl:@"" forKey:ECOMMERCE_URL];
    [pObj setObject:IS_POPULATED_STRING(self.authorName)?self.authorName:@"" forKey:AUTHOR_NAME];
    [pObj setObject:IS_POPULATED_STRING(self.shortDesc)?self.shortDesc:@"" forKey:SHORT_DESC];

   // [pObj setObject:[NSDate date] forKey:EVENTS_TIME];
    [pObj setObject:self.ageFrom?self.ageFrom:[NSNumber numberWithInt:0] forKey:AGE_FROM];
    [pObj setObject:self.ageTo?self.ageTo:[NSNumber numberWithInt:0] forKey:AGE_TO];
    [pObj setObject:self.noOfLikes?self.noOfLikes:[NSNumber numberWithInt:0] forKey:NUMBER_OF_LIKES];
    [pObj setObject:self.noOfComments?self.noOfComments:[NSNumber numberWithInt:0] forKey:NUMBER_OF_COMMENTS];
   // [pObj setObject:IS_POPULATED_STRING(self.authorId)?self.authorId:@"" forKey:AUTHOR_ID];
    [pObj setObject:IS_POPULATED_STRING(self.status)?self.status:@"" forKey:STATUS];
    if (self.coverPic) {
        [pObj setObject:self.coverPic forKey:COVER_PAGE];
    }
    if (self.pdfFile) {
        [pObj setObject:self.pdfFile forKey:PDF_FILE];
    }
    if (self.authorId) {
        [pObj setObject:self.authorId forKey:AUTHOR_ID];
    }
    return pObj;
}

-(void)saveBooksBlock:(AuthorIdResultBlock)block{
    PFObject *pObj=[self convertBooksToPFObject];
    [pObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            block([Book convertPFObjectToBooks:pObj],nil);
        }else{
            block(nil,error);
        }
    }];
    
}

-(void)saveBooksInBackground{
    PFObject *pObj=[self convertBooksToPFObject];
    [pObj saveInBackground];
    
}
-(void)fetchBookBlock:(arrayResultBlock)block
{
    PFQuery *query=[PFQuery queryWithClassName:BOOK];
    [query includeKey:AUTHOR_ID];
    [query orderByDescending:NUMBER_OF_LIKES];
    [query whereKey:TYPE equalTo:@"Normal"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *results=[[NSMutableArray alloc] init];
            for (PFObject *obj in objects) {
                Book *events=[Book convertPFObjectToBooks:obj];
              //  User *author = [];
                [results addObject:events];
            }
            block(results,nil);
            
        }else{
            block(nil,error);
        }
    }];
}

@end
