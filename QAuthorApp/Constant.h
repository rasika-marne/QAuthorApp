//
//  Constant.h
//  CreateBookApp
//
//  Created by Rasika  on 9/24/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#ifndef CreateBookApp_Constant_h
#define CreateBookApp_Constant_h
#import <Parse/Parse.h>
#import "AppDelegate.h"
#define PARSE_APP_ID        @"b55Heb0ojSNVlLckCZpaSoK6sG32n6kdyKlWvooR"
#define PARSE_CLIENT_KEY    @"nSegiph82jjOWoJeNqZ035fG2zozfoOMN7zfHt9G"
#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
#define kColumnMargin 10
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define  RECORD_BUTTON_TAG 111
#define  STOP_RECORDING_BUTTON_TAG 222
#define AUDIO_RECORD_BUTTON_INDEX   1
#define RECORD_AUDIO_START_BUTTON @"recordvoice-start-button.png"
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define RECORD_AUDIO_BUTTON  @"recordvoice.png"
#define OBJECT_ID @"objectId"

#define USER_ID @"UserId"
#define IS_EMPTY_STRING(str) (!(str) || ![(str) isKindOfClass:NSString.class] || [(str) length] == 0)
#define IS_POPULATED_STRING(str) ((str) && [(str) isKindOfClass:NSString.class] && [(str) length] > 0)
#define IS_POPULATED_INTEGER(str) (str && [str isKindOfClass:] && [(str) length] > 0)
#define TRIM_CHARACTER_SET [NSCharacterSet whitespaceAndNewlineCharacterSet]
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define NAVBARCOLOR [UIColor  colorWithRed:17.0/255.0f green:65.0/255.0f blue:97.0/255.0f alpha:1.0f]
#define NAVIGATIONRGB [UIColor colorWithRed:17/255.0 green:65/255.0 blue:97/255.0 alpha:1]
#define RGB [UIColor colorWithRed:114/255.0 green:197/255.0 blue:213/255.0 alpha:1]
//#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//Facebook credentials
#define FbClientID @"423047544565291"

#define AD_Unit_id @"ca-app-pub-5468147316620707/4430610672"

//Custom Font
#define FONTNAME @"AvenirLTStd-Light"
#define FONTSIZE @"14.00"

#define BOLDFONTNAME @"AvenirLTStd-Heavy"
#define BOLDFONTSIZE @"16"
// Debugging
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
NSString *SELECTEDBOOKID,*SelectedSegmentvalue;
UIImage *selectedTemplate;
typedef void (^UserIdResultBlock)(id object, NSError *error);
#define KMessageCount @"messageCnt"
//---------- User Constant -------//

#define USER                @"User"
#define USER_OBJECT_ID      @"objectId"
#define EMAIL_ID            @"email"
#define FIRST_NAME          @"first_name"
#define LAST_NAME           @"last_name"
#define PASSWORD            @"password"
#define PROFILE_PIC         @"profilePic"
#define USERNAME            @"username"
#define AGE                 @"age"
#define CITY                @"city"
#define LANGUAGE            @"language"
#define STATUS              @"status"
#define ROLE                @"role"
#define COUNTRY             @"country"
#define FAVORITE_AUTHOR1    @"favoriteAuthor1"
#define FAVORITE_AUTHOR2    @"favoriteAuthor2"
#define FAVORITE_AUTHOR3    @"favoriteAuthor3"
#define NEW_AUTHOR1         @"newAuthor1"
#define NEW_AUTHOR2         @"newAuthor2"
#define FACEBOOK_ID         @"FacebookId"



//---------- Book Constant -------//

#define BOOK                @"Book"
#define BOOK_OBJECT_ID      @"objectId"
#define TITLE               @"title"
#define GENRE               @"genre"
#define SHORT_DESC          @"description"
#define AUTHOR_ID           @"authorId"
#define AGE_FROM            @"ageFrom"
#define AGE_TO              @"ageTo"
#define NUMBER_OF_LIKES     @"numberOfLikes"
#define NUMBER_OF_COMMENTS  @"numberOfComments"
#define STATUS              @"status"
#define COVER_PAGE          @"coverPage"
#define PDF_FILE            @"pdfFile"
#define TYPE                @"type"
#define AUTHOR_NAME         @"authorName"
#define ECOMMERCE_URL       @"eCommerceUrl"
#define PRICE               @"price"
#define CREATED_AT          @"createdAt"


//---------- BookDetails Constant -------//

#define BOOK_DETAILS                @"BookDetails"
#define BOOK_DETAILS_OBJECT_ID      @"objectId"
#define BOOK_ID                     @"bookId"
#define PAGE_NUMBER                 @"pageNumber"
#define TEXT_CONTENT                @"textContent"
#define IMAGE_CONTENT               @"imageContent"
#define AUDIO_CONTENT               @"audioContent"
#define PAGE_PDF                    @"pagePDF"


//---------- AgeRange Constant -------//

#define AGE_RANGE                   @"AgeRange"
#define AGE_TO                      @"ageTo"
#define AGE_FROM                    @"ageFrom"

//---------- Book Genre Constant -------//

#define BOOK_GENRE                @"Book_Genre"

//---------- Book Comment Constant -------//

#define BOOK_COMMENT                @"Book_Comment"
#define COMMENT_BOOK_ID             @"bookID"
#define COMMENT                     @"comment"
#define COMMENT_USER_ID             @"userId"
#define COMMENT_USER_NAME           @"userName"


//---------- Book Like Constant -------//

#define BOOK_LIKES                  @"Book_Likes"
#define LIKE_BOOK_ID                @"bookId"
#define LIKE_USER_ID                @"userId"


//---------- FanFollowers Constant -------//

#define FAN_FOLLOWERS                  @"FanFollowers"
#define FOLLOWERS                      @"followers"
#define FAN_USER_ID                    @"userId"




#endif
