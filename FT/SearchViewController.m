//
//  SearchViewController.m
//  FT
//
//  Created by Damian Troncoso on 9/28/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "SearchViewController.h"
#import "Offer.h"
#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"
#import "AFNetworking.h"
#import "OffersResponse.h"
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

- (void)loadOffers {
    [self.searchButton setEnabled:NO];
    [self.activityIndicator startAnimating];
    
    NSString* apiKey = @"1c915e3b5d42d05136185030892fbb846c278927";
    
    NSDictionary *queryParams = @{@"appid" : [NSNumber numberWithInt:2070],
                                          @"uid" : @"spiderman",
                                          @"locale": @"DE",
                                          @"ip" : @"109.235.143.113",
                                          @"ps_time" : @"20140118",
                                          @"timestamp" : [NSString stringWithFormat:@"%lli",(long long)([[NSDate date] timeIntervalSince1970])] };
    
    NSString* queryString = [queryParams queryStringValueAlphabeticalOrder];
    NSString* conc = [NSString stringWithFormat:@"%@&%@", queryString, apiKey];
    NSString* hash = [conc sha1];
    
    queryString = [NSString stringWithFormat:@"%@?%@&%@=%@", @"http://api.sponsorpay.com/feed/v1/offers.json", queryString, @"hashkey", hash];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:queryString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.offers = [OffersResponse responseWithData:(NSDictionary*)responseObject];
        [self performSegueWithIdentifier:@"Search" sender:self];
        
        [self.searchButton setEnabled:YES];
        [self.activityIndicator stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    
    [self loadOffers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Search"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        OffersListController *secondController = [navigationController viewControllers][0];
            
        secondController.offers = self.offers;
    }
}

@end
