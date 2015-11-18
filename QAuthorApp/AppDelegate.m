//
//  AppDelegate.m
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "AppDelegate.h"
#import "RearViewController.h"

static NSString *const kTrackingId = @"UA-70308797-1";
static NSString *const kAllowTracking = @"allowTracking";
@interface AppDelegate ()<SWRevealViewControllerDelegate>
@property(nonatomic, assign) BOOL okToWait;
@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);
@end
// Used for sending Google Analytics traffic in the background.

@implementation AppDelegate
@synthesize viewController,loggedInUser,activitityIndicator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure tracker from GoogleService-Info.plist.
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    
    // If your app runs for long periods of time in the foreground, you might consider turning
    // on periodic dispatching.  This app doesn't, so it'll dispatch all traffic when it goes
    // into the background instead.  If you wish to dispatch periodically, we recommend a 120
    // second dispatch interval.
    // [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].dispatchInterval = -1;
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"QAuthor"
                                              trackingId:kTrackingId];
    
  // remove before app release

    // Override point for customization after application launch.
        [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
    
    //For Apns
    if (IS_OS_8_OR_LATER) {
        // In iOS 8 onwards , we need to register for remote notification & local notificatio SEPARATELY
        //to get location
        //[self.locationManager requestWhenInUseAuthorization];
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    loggedInUser = [User createEmptyUser];
     [FBAppEvents activateApp];
    // [self tabBarSetup];
    if ([self getLoggedInUserName] == NULL) {
        [self firstTimeLogin];
    }
    else
    {
        [self doLogin];
        
    }
    
   [application setApplicationIconBadgeNumber:0];
       return YES;
}

- (void)sendHitsInBackground {
    self.okToWait = YES;
    __weak AppDelegate *weakSelf = self;
    __block UIBackgroundTaskIdentifier backgroundTaskId =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        weakSelf.okToWait = NO;
    }];
    
    if (backgroundTaskId == UIBackgroundTaskInvalid) {
        return;
    }
    
    self.dispatchHandler = ^(GAIDispatchResult result) {
        // If the last dispatch succeeded, and we're still OK to stay in the background then kick off
        // again.
        if (result == kGAIDispatchGood && weakSelf.okToWait ) {
            [[GAI sharedInstance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
        }
    };
    [[GAI sharedInstance] dispatchWithCompletionHandler:self.dispatchHandler];
}

-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self sendHitsInBackground];
    completionHandler(UIBackgroundFetchResultNewData);
}

// We'll try to dispatch any hits queued for dispatch as the app goes into the background.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self sendHitsInBackground];
}

/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
   // return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                     //     openURL:url
                                               // sourceApplication:sourceApplication
                                          //             annotation:annotation];
}*/
-(void)doLogin{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   // if ([InternetConnection isInternetConnectionAvailable] ) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *flag = [defaults valueForKey:@"LoginUserSucessFlag"];
         if ([flag isEqualToString:@"Yes"]) {
           /* if (object) {
                [APP_DELEGATE stopActivityIndicator];
                DLog(@"Login Success");
                APP_DELEGATE.loggedInUser = (User*)object;
                [APP_DELEGATE saveLoggedInUserId:APP_DELEGATE.loggedInUser.objectId andPwd:[self getLoggedInUserPassword] andUserName:[self getLoggedInUserName]];
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:APP_DELEGATE.loggedInUser.objectId forKey:@"userId"];
                [currentInstallation saveInBackground];*/
                
                self.homeVC = (HomeViewController *)
                [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                self.uniNavController = self.navigationController;
               UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
                RearViewController *rearViewController = [[RearViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nav frontViewController:frontNavigationController];
                revealController.delegate = self;
                  self.window.rootViewController = revealController;
                [self.window makeKeyAndVisible];
         }
    
    
    //}
    
}
#pragma mark - Save & Get LoggedIn User Detail

-(void)saveLoggedInUserId:(NSString*)userId andPwd:(NSString*)pwd andUserName:(NSString *)name{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:userId forKey:USER_ID];
    if (pwd.length>0) {
        [userDefault setValue:pwd forKey:@"Password"];
    }
    [userDefault setObject:name forKey:@"UserName"];
    [userDefault synchronize];
}

-(NSString*)getLoggedInUserId{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:USER_ID];
}

-(NSString*)getLoggedInUserPassword{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"Password"];
}
-(NSString*)getLoggedInUserName{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"UserName"];
}


-(void)clearLoggedInUserDetail{
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:USER_ID];
    [userDefault setObject:nil forKey:@"Password"];
    [userDefault setObject:nil forKey:@"UserName"];
    [userDefault synchronize];
}
-(void)logout
{
    
    [PFUser logOut];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"loggedInUser"];
    if (self.viewController) {
        self.viewController = nil;
    }
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = (ViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.uniNavController = self.navigationController;
    self.window.rootViewController = self.navigationController;
     self.navigationController.navigationBar.barTintColor =NAVBARCOLOR;
    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PINForManagerAndCoach"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KMessageCount];
    
    [User logout];
}

-(void)firstTimeLogin
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.signUpVC = (SignUpViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.signUpVC];
    self.uniNavController = self.navigationController;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
}
#pragma mark Activity Indicator Methods -
- (void)startActivityIndicator:(UIView *)view
{
    if(self.activitityIndicator)
        [self.activitityIndicator removeFromSuperview];
    [self setActivitityIndicator:nil];
    activitityIndicator = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:activitityIndicator];
    activitityIndicator.dimBackground = NO;
    activitityIndicator.labelText = @"Please wait...";
    [activitityIndicator show:YES];
}

- (void)stopActivityIndicator
{
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    [self.activitityIndicator removeFromSuperview];
    if(self.activitityIndicator)
        [self setActivitityIndicator:nil];
}
#pragma mark
#pragma mark ============== Check network connection method ========================
// Check network connection....
-(BOOL)hasConnectivity {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    
    if(reachability != NULL) {
        
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)  {
                
                // if target host is not reachable
                return NO;
            }
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)  {
                
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))  {
                
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [application setApplicationIconBadgeNumber:0];
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];
   // [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


#pragma mark - Public method implementation

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
