//
//  ShareScreen.m
//  GooglePlusSignIn
//
//  Created by Ashish Pisey on 9/8/14.
//  Copyright (c) 2014 com.AshishPisey. All rights reserved.
//

#import "ShareScreen.h"

@interface ShareScreen ()
{
    NSString *currentFBUserName;
}

@end

@implementation ShareScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareOnGoogleAction:(UIButton *)sender
{
    
}

-(void)getUserNamePicture
{
    
    ////////////// get user FB name ////////////////////////////
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
             NSString *fbUserId = [(NSString *)[result objectForKey:@"id"] mutableCopy];
             //             NSLog(@"fb id %@",fbUserId);
             
             NSString *nameURLString=[NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=name",fbUserId];
             
             //  NSString *nameURLString=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100",fbUserId];
             //NSLog(@"fbuserID %@",fbUserId);
             NSURL *url=[NSURL URLWithString:nameURLString];
             NSData *data1=[NSData dataWithContentsOfURL:url];
             // json parsing to convert json response returned by fb into dictionary
             NSDictionary *allDataDictionary1=[NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
             currentFBUserName=[allDataDictionary1 objectForKey:@"name"];
          
             // Get Image
             NSString *profileImgString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100",fbUserId];
             NSURL *profileUrl = [NSURL URLWithString:profileImgString];
             
             UIImage *profileImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:profileUrl]];
         }
     }];
    /////////////////////////////////////////////////////////
    NSLog(@"done");
}


- (IBAction)shareOnFBAction:(UIButton *)sender
{
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                       defaultAudience:FBSessionDefaultAudienceOnlyMe
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                         if (!error && status == FBSessionStateOpen) {
                                             [self shareFBPost];
                                         }else{
                                             NSLog(@"error %@",error);
                                         }
                                     }];

}

-(void)shareFBPost
{
    
    //    [SVProgressHUD showWithStatus:@"Posting To Facebook"];
    
    NSString *photoURLString = @"http://9to5mac.files.wordpress.com/2014/01/nikola-cirkovic.jpg?w=704&h=436";
    NSURL *photoUrl = [NSURL URLWithString:photoURLString];
    //    NSLog(@"photo url string %@",photoURLString);
    
    NSString *urlString = @"http://www.quora.com/";
    NSURL *urlToShare = [NSURL URLWithString:urlString];
    NSString *textToShare = @"iPhone 6 is coming";
    NSString *caption = @"Attention";
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:@"Quora"
                                                       caption:caption
                                                   description:textToShare
                                                       picture:photoUrl
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               // POP TO ROOT HOME VIEW CONTROLLER
                                                               
                                                               /*[defaults setBool:YES forKey:@"isPhotoShared"];
                                                                
                                                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                                                                NSLog(@"Success!");
                                                                */
                                                               
                                                               UIAlertView *shareAlert = [[UIAlertView alloc]initWithTitle:@"Shared On Facebook" message:@"SuccessFully shared Post on your Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                               
                                                               [shareAlert show];
                                                               
                                                               //                                                               [SVProgressHUD dismiss];
                                                               //
                                                               //                                                               [Flurry logEvent:@"Photo shared on FB by user" withParameters:[NSDictionary dictionaryWithObject:currentUserFbName forKey:@"FB Username"]];
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:textToShare
                                                                                    image:[UIImage imageWithData:[NSData dataWithContentsOfURL:photoUrl]]
                                                                                      url:urlToShare
                                                                                  handler:nil];
        //        [SVProgressHUD dismiss];
        
        if (!displayedNativeDialog) {
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    textToShare, @"message",
                                    urlString, @"link",
                                    photoURLString, @"picture",
                                    nil
                                    ];
            /* make the API call */
            [FBRequestConnection startWithGraphPath:@"/me/feed"
                                         parameters:params
                                         HTTPMethod:@"POST"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                      if (error)
                                      {
                                          NSLog(@"error :: %@", error);
                                      }
                                      else
                                      {
                                          NSLog(@"result :: %@", result);
                                          
                                          UIAlertView *shareAlert = [[UIAlertView alloc]initWithTitle:@"Shared On Facebook" message:@"SuccessFully shared Post on your Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                          
                                          [shareAlert show];
                                          
                                          //                                          [SVProgressHUD dismiss];
                                          // POP TO ROOT HOME VIEW CONTROLLER
                                          
                                          /* [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPhotoShared"];
                                           
                                           [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                                           
                                           [Flurry logEvent:@"Photo shared on FB by user" withParameters:[NSDictionary dictionaryWithObject:currentUserFbName forKey:@"FB Username"]];
                                           */
                                          
                                      }
                                      
                                  }];
            
        }
        
    }
    
}


@end
