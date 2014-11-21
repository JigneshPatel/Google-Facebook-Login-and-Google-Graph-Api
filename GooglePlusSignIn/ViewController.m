//
//  ViewController.m
//  GooglePlusSignIn
//
//  Created by Ashish Pisey on 9/1/14.
//  Copyright (c) 2014 com.AshishPisey. All rights reserved.
//

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "AppDelegate.h"

@interface ViewController ()
{
    GPPSignIn *signIn;
    NSString *currentFBUserName;
    BOOL isGoogleLoggedIn;
    NSString *fbUserId;
    NSString *currentUserFbName;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    if ((FBSession.activeSession.state == FBSessionStateOpen
         || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)||isGoogleLoggedIn) {
        
        [self performSegueWithIdentifier:@"toShareScreen" sender:self];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"535047152601-qm2n14usnfspegmv8jop47faka2q2poc.apps.googleusercontent.com";
    
    //Uncomment one of these two statements for the scope you chose in the previous step
   // signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    self.signInSuccessLabel.hidden = YES;
    
    [signIn trySilentAuthentication];
}

#pragma mark Google-Plus SignIn

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        self.signInSuccessLabel.hidden = NO;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        self.signInSuccessLabel.hidden = YES;
        // Perform other actions here
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    NSLog(@"Received Access Token:%@",auth);
    NSLog(@"user google user id  %@",signIn.userEmail); //logged in user's email id
    
    if (error) {
        // Do some error handling here.
        NSLog(@"Error :- %@",error);
    } else {
        [self refreshInterfaceBasedOnSignIn];
        
        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled ; YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                        collection:kGTLPlusCollectionVisible];
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPeopleFeed *peopleFeed,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        // Get an array of people from GTLPlusPeopleFeed
                        NSArray* peopleList = peopleFeed.items;
                        NSLog(@"People list %@",[peopleList firstObject]);
                    }
                }];

    }
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
   // [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}

# pragma mark FACEBOOK Implementation

-(void)checkIfLoggedIn
{
    if ((FBSession.activeSession.state == FBSessionStateOpen
         || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)||isGoogleLoggedIn) {
        
        [self performSegueWithIdentifier:@"toShareScreen" sender:self];
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             NSLog(@"session state %u",state);
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
         }];
        [self performSegueWithIdentifier:@"toShareScreen" sender:self];

    }
    
}

- (IBAction)facebookBtnAction:(UIButton *)sender {
    [self checkIfLoggedIn];
}




@end
