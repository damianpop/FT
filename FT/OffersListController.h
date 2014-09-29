//
//  OffersListController.h
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersLoader.h"

@interface OffersListController : UITableViewController

@property OffersLoader* offers;

- (IBAction)done:(id)sender;

@end
