//
//  ViewController.h
//  GooglePlusSignIn
//
//  Created by Ashish Pisey on 9/1/14.
//  Copyright (c) 2014 com.AshishPisey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
 
@class GPPSignInButton;
@interface ViewController : UIViewController<GPPSignInDelegate>
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInSuccessLabel;
- (IBAction)facebookBtnAction:(UIButton *)sender;
@end
