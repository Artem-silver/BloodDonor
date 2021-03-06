//
//  StationsViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreLocationController.h"
#import <Parse/Parse.h>

@interface StationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMapViewDelegate, MKAnnotation>
{
    IBOutlet UIView *contentView;
    
    IBOutlet UIButton *backButton;
    
    IBOutlet UIButton *tableButton;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *filterButton;
    
    IBOutlet UIView *searchContainerView;
    IBOutlet UIView *barView;
    IBOutlet UIView *searchView;
   
    IBOutlet UITextField *searchField;
    
    IBOutlet UIView *stationsTableView;
    IBOutlet UIView *stationsMapView;
    
    IBOutlet MKMapView *stationsMap;
    IBOutlet UITableView *stationsTable;
    
    UIView *indicatorView;
    
    NSMutableDictionary *tableDictionary;
    NSMutableDictionary *searchTableDictionary;
    NSMutableArray *stationsArrayList;
    
    CLLocation *currentLocation;
    
    BOOL isShowOneStation;
    
    PFObject *selectedStationToShowOnMap;
}

@property (nonatomic, retain) CoreLocationController *coreLocationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)station;

- (IBAction)switchView:(id)sender;
- (IBAction)searchPressed:(id)sender;
- (IBAction)searchCancelPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;

//- (void)showOnMap:(PFObject *)station;

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;
- (void)reloadMapAnnotations;

@end
