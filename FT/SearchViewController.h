//
//  SearchViewController.h
//  FT
//
//  Created by Damian Troncoso on 9/28/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersLoader.h"

@interface SearchViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UITextField *userId;
@property (weak, nonatomic) IBOutlet UITextField *apiKey;
@property (weak, nonatomic) IBOutlet UITextField *locale;
@property (weak, nonatomic) IBOutlet UITextField *ip;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property OffersLoader* offers;
@property NSError* error;

- (IBAction)search:(id)sender;

@end
