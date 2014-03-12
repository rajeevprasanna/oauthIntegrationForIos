//
//  ViewController.m
//  oauthDemo
//
//  Created by Rajeev Kumar on 12/03/14.
//  Copyright (c) 2014 rajeev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *arrProfileInfo;
@property (nonatomic, strong) NSMutableArray *arrProfileInfoLabel;
@property (nonatomic, strong) GoogleOauthWebview *googleOAuth;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    _arrProfileInfo = [[NSMutableArray alloc] init];
    _arrProfileInfoLabel = [[NSMutableArray alloc] init];
    
    _googleOAuth = [[GoogleOauthWebview alloc] initWithFrame:self.view.frame];
    [_googleOAuth setGoAuthDelegate:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrProfileInfo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        [[cell textLabel] setFont:[UIFont fontWithName:@"Trebuchet MS" size:15.0]];
        [[cell textLabel] setShadowOffset:CGSizeMake(1.0, 1.0)];
        [[cell textLabel] setShadowColor:[UIColor whiteColor]];
        
        [[cell detailTextLabel] setFont:[UIFont fontWithName:@"Trebuchet MS" size:13.0]];
        [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
    }
    
    [[cell textLabel] setText:[_arrProfileInfo objectAtIndex:[indexPath row]]];
    [[cell detailTextLabel] setText:[_arrProfileInfoLabel objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (IBAction)revokeAccess:(id)sender {
    [_googleOAuth revokeAccessToken];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(void)authorizationWasSuccessful{
    [_googleOAuth callAPI:@"https://www.googleapis.com/oauth2/v1/userinfo"
           withHttpMethod:httpMethod_GET
       postParameterNames:nil postParameterValues:nil];
}

-(void)accessTokenWasRevoked{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Your access was revoked!"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [_arrProfileInfo removeAllObjects];
    [_arrProfileInfoLabel removeAllObjects];
    
    [_table reloadData];
}

-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails{
    NSLog(@"%@", errorShortDescription);
    NSLog(@"%@", errorDetails);
}

-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData{
    if ([responseJSONAsString rangeOfString:@"family_name"].location != NSNotFound) {
        NSError *error;
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseJSONAsData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error];
        if (error) {
            NSLog(@"An error occured while converting JSON data to dictionary.");
            return;
        }
        else{
            if (_arrProfileInfoLabel != nil) {
                _arrProfileInfoLabel = nil;
                _arrProfileInfo = nil;
                _arrProfileInfo = [[NSMutableArray alloc] init];
            }
            
            _arrProfileInfoLabel = [[NSMutableArray alloc] initWithArray:[dictionary allKeys] copyItems:YES];
            for (int i=0; i<[_arrProfileInfoLabel count]; i++) {
                [_arrProfileInfo addObject:[dictionary objectForKey:[_arrProfileInfoLabel objectAtIndex:i]]];
            }
            
            [_table reloadData];
        }
    }
}

-(void)errorInResponseWithBody:(NSString *)errorMessage{
    NSLog(@"%@", errorMessage);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showProfile:(id)sender {
    [_googleOAuth authorizeUserWithClientID:@"4516271788433-npfpoi6el7noilv874ammjfupaaqljqc.apps.googleusercontent.com" andClientSecret:@"op2KDfJ4VkLdpGwM4uFPX6h-j" andParentView:self.view andScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile", nil]];
}
@end
