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

- (void)loadOffersUserID:(NSString*) userId apiKey:(NSString*)apiKey locale:(NSString*)locale ip:(NSString*)ip {
    [self.searchButton setEnabled:NO];
    [self.activityIndicator startAnimating];
    
    self.offers = [[OffersLoader alloc] init];
    [self.offers loadOffersUserID:userId apiKey:apiKey locale:locale ip:ip success:^(void){
        [self performSegueWithIdentifier:@"Search" sender:self];
        
        [self.searchButton setEnabled:YES];
        [self.activityIndicator stopAnimating];
    } failure:^(NSError* error){
        NSLog(@"Error: %@", error);
        
        [self.searchButton setEnabled:YES];
        [self.activityIndicator stopAnimating];
    }];
    
}

- (IBAction)search:(id)sender {
    NSString* sUserId = self.userId.text;
    NSString* sApiKey = self.apiKey.text;
    NSString* sLocale = self.locale.text;
    NSString* sIP = self.ip.text;
    
    [self loadOffersUserID:sUserId apiKey:sApiKey locale:sLocale ip:sIP];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Search"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        OffersListController *secondController = [navigationController viewControllers][0];
            
        secondController.offers = self.offers;
    }
}

@end
