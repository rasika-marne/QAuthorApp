//
//  BookDetails.h
//  QAuthorApp
//
//  Created by Rasika  on 10/6/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <Parse/Parse.h>
#import "Constant.h"
typedef void (^AuthorIdResultBlock)(id object, NSError *error);
typedef void (^arrayResultBlock)(NSMutableArray *objects, NSError *error);

@interface BookDetails : PFObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSString *textContent;

@property (nonatomic, strong) PFFile *imageContent;
@property (nonatomic, strong) PFFile *audioContent;
@property (nonatomic, strong) PFFile *pagePDF;


-(PFObject*)convertBookDetailsToPFObject;
+(BookDetails *)convertPFObjectToBookDetails:(PFObject *)pobj;
-(void)saveBookDetailsBlock:(AuthorIdResultBlock)block;
+(BookDetails *)createEmptyObject;
//-(void)saveBookDetailsInBackground;
-(void)fetchBookDetailBlockForBook:(NSString *)bookId block1:(arrayResultBlock)block;
@end
