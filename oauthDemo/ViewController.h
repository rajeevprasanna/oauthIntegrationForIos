//
//  ViewController.h
//  oauthDemo
//
//  Created by Rajeev Kumar on 12/03/14.
//  Copyright (c) 2014 rajeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleOauthWebview.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)showProfile:(id)sender;

- (IBAction)revokeAccess:(id)sender;

@end
