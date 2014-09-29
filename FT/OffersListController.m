//
//  OffersListController.m
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import "OffersListController.h"
#import "Offer.h"
#import "UIKit+AFNetworking.h"

@interface OffersListController ()

@end

@implementation OffersListController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.offers.offers count];
    if(self.offers.pages - self.offers.pagesLoaded > 0) count++;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    if(index < self.offers.offers.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
        Offer *player = (self.offers.offers)[indexPath.row];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
        titleLabel.text = player.title;
    
        UILabel *teaserLabel = (UILabel *)[cell viewWithTag:101];
        teaserLabel.text = player.teaser;
        [teaserLabel sizeToFit];
    
        UILabel *payoutLabel = (UILabel *)[cell viewWithTag:102];
        payoutLabel.text = [NSString stringWithFormat:@"Payout: %i", player.payout];
    
        UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:103];
        [thumbnailImageView setImage:nil];
        [thumbnailImageView setImageWithURL:[NSURL URLWithString:player.thumbnailUrl]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore"];
        [self.offers loadNextPageSuccess:^{
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        return cell;
    }
    
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
