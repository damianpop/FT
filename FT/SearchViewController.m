//
//  SearchViewController.m
//  FT
//
//  Created by Damian Troncoso on 9/28/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "SearchViewController.h"
#import "Offer.h"
#import "OffersLoader.h"
#import "OffersListController.h"
#import "ErrorViewController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if(textField == self.userId) [self.apiKey becomeFirstResponder];
    else if(textField == self.apiKey) [self.locale becomeFirstResponder];
    else if(textField == self.locale) [self.ip becomeFirstResponder];
    else [textField resignFirstResponder];
 
    return NO;
}

-(void)keyboardWillShow {
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp {
    int offset = 512 - [[UIScreen mainScreen] bounds].size.height;
    if(offset > 0){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
    
        CGRect rect = self.view.frame;
        if (movedUp) {
            rect.origin.y -= offset;
            rect.size.height += offset;
            self.tableView.tableHeaderView.hidden = YES;
        }  else  {
            rect.origin.y += offset;
            rect.size.height -= offset;
            self.tableView.tableHeaderView.hidden = NO;
        }
        self.view.frame = rect;
    
        [UIView commitAnimations];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadOffersUserID:(NSString*) userId apiKey:(NSString*)apiKey locale:(NSString*)locale ip:(NSString*)ip {
    [self.searchButton setEnabled:NO];
    [self.activityIndicator startAnimating];
    
    self.offers = [[OffersLoader alloc] init];
    [self.offers loadOffersUserID:userId apiKey:apiKey locale:locale ip:ip success:^(void){
        self.error = nil;
        if(self.offers.offers.count  == 0) [self performSegueWithIdentifier:@"Error" sender:self];
        else [self performSegueWithIdentifier:@"Search" sender:self];
        
        [self.searchButton setEnabled:YES];
        [self.activityIndicator stopAnimating];
    } failure:^(NSError* aerror){
        self.error = aerror;
        [self performSegueWithIdentifier:@"Error" sender:self];
        
        [self.searchButton setEnabled:YES];
        [self.activityIndicator stopAnimating];
    }];
    
}

- (IBAction)search:(id)sender {
    NSString* sUserId = self.userId.text;
    NSString* sApiKey = self.apiKey.text;
    NSString* sLocale = self.locale.text;
    NSString* sIP = self.ip.text;
    
    [self.view endEditing:YES];
    
    [self loadOffersUserID:sUserId apiKey:sApiKey locale:sLocale ip:sIP];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Search"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        OffersListController *secondController = [navigationController viewControllers][0];
            
        secondController.offers = self.offers;
    } else if([[segue identifier] isEqualToString:@"Error"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ErrorViewController *secondController = [navigationController viewControllers][0];
        
        if(self.error == nil) secondController.errorMessage = @"No Offers";
        else secondController.errorMessage = self.error.localizedDescription;
    }
}

@end
