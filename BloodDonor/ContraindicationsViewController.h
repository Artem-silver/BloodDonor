//
//  ContraindicationsViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 05.08.12.
//
//

#import <UIKit/UIKit.h>

@interface ContraindicationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIButton *absoluteButton;
    IBOutlet UIButton *timeButton;
    
    IBOutlet UITableView *contraindicationsTableView;
    IBOutlet UIView *searchView;
    IBOutlet UIView *absoluteSearchView;
    IBOutlet UIView *timeSearchView;
    BOOL isSearch;
    IBOutlet UITextField *absoluteSearchTextField;
    IBOutlet UITextField *timeSearchTextField;
    IBOutlet UIView *hideBarView;
    NSMutableArray *absoluteLevel0Array;
    NSMutableArray *absoluteLevel1Array;
    NSMutableArray *absoluteLevel2Array;
    NSMutableArray *timeContentArray;

    NSMutableArray *timeLevel0Array;
    NSMutableArray *timeLevel1Array;
    NSMutableArray *timeLevel2Array;
    
    NSMutableArray *searchArray;
    
    UIView *indicatorView;
}

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)tabSelected:(id)sender;
- (IBAction)searchCancelPressed:(id)sender;

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;

@end
