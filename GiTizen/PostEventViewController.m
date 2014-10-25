//
//  PostEventViewController.m
//  GiTizen
//
//  Created by Zhao Yiwei on 10/19/14.
//  Copyright (c) 2014 Pangu. All rights reserved.
//

#import "PostEventViewController.h"
#import "EventCenterTableViewCell.h"
#import "PlacesViewController.h"
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PostEventViewController ()<CLLocationManagerDelegate, UISearchBarDelegate >

@property (strong, nonatomic) Event *eventToPost;
@property (weak, nonatomic) IBOutlet UITextField *categoryStr;
@property (weak, nonatomic) IBOutlet UITextField *timeStr;
@property (weak, nonatomic) IBOutlet UITextField *nopStr;
@property (weak, nonatomic) IBOutlet UITextField *titleStr;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation PostEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initField];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postIt)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initField
{
    self.eventToPost = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.persistentStoreManagedObjectContext];
    //UIImage *btnImage = [UIImage imageNamed:@"image.png"];
    //[self.searchButton setImage:btnImage forState:UIControlStateNormal];
    //[self.searchButton addTarget:self action:@selector(buttonCLick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Managing the Google location information item
- (void)setGPlace:(Place*) googlePlace{
    if (_gPlace != googlePlace) {
        _gPlace = googlePlace;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchLoc"])
    {
        //NSLog(@"%@",self.titleStr.text);
        [segue.destinationViewController setSearchText:self.titleStr.text];
    }
}
    
- (void)postIt {
    if(self.gPlace){
        self.eventToPost.g_loc_name = self.gPlace.name;
        self.eventToPost.g_loc_addr = self.gPlace.formattedAddress;
        self.eventToPost.g_loc_id = self.gPlace.placeId;
        self.eventToPost.g_loc_icon = self.gPlace.icon;
        NSLog(@"name: %@, addr: %@",self.gPlace.name, self.gPlace.address);
    }
    self.eventToPost.category = self.categoryStr.text;
    self.eventToPost.starttime = self.timeStr.text;
    self.eventToPost.number_of_peo = self.nopStr.text;
    
    [[RKObjectManager sharedManager]    postObject:self.eventToPost
                                              path:@"/api/events"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                               NSLog(@"Post succeeded");
                                           }
                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               NSLog(@"error occurred': %@", error);
                                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end