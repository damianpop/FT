//
//  ErrorViewController.h
//  FT
//
//  Created by Damian Troncoso on 9/29/14.
//  Copyright (c) 2014 damiantroncoso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *errorMsgLabel;

@property NSString* errorMessage;

- (IBAction)done:(id)sender;

@end
