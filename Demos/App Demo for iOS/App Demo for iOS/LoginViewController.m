//
//  SignInViewController.m
//  1Password Extension Demo
//
//  Created by Rad on 2014-07-14.
//  Copyright (c) 2014 AgileBits. All rights reserved.
//

#import "LoginViewController.h"
#import <OnePasswordExtension/OnePasswordExtension.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *onepasswordSigninButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"login-background.png"]]];

	NSBundle *onePasswordExtensionBundle = [NSBundle bundleForClass:[OnePasswordExtension class]];
	UIImage *onePasswordButtonImage = [UIImage imageNamed:@"onepassword-button" inBundle:onePasswordExtensionBundle compatibleWithTraitCollection:self.traitCollection];
	[self.onepasswordSigninButton setImage:onePasswordButtonImage forState:UIControlStateNormal];
	[self.onepasswordSigninButton setHidden:![[OnePasswordExtension sharedExtension] isAppExtensionAvailable]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)findLoginFrom1Password:(id)sender {
	[[OnePasswordExtension sharedExtension] findLoginForURLString:@"https://www.acme.com" forViewController:self sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
		if (!loginDict) {
			if (error.code != AppExtensionErrorCodeCancelledByUser) {
				NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
			}
			return;
		}
		
		self.usernameTextField.text = loginDict[AppExtensionUsernameKey];
		self.passwordTextField.text = loginDict[AppExtensionPasswordKey];
	}];
}

@end
