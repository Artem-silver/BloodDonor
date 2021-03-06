//
//  ProfileRegistrationViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileRegistrationViewController.h"
#import "SelectBloodGroupViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import <Parse/Parse.h>
#import "MessageBoxViewController.h"
#import "ProfileDescriptionViewController.h"

@implementation ProfileRegistrationViewController

#pragma mark Actions

- (IBAction)cancelButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClick:(id)sender
{
    if (![passwordTextField.text isEqual: passwordConfirmTextField.text])
    {
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                          bundle:nil
                                                                                           title:nil
                                                                                         message:@"Пароли не совпадают"
                                                                                    cancelButton:@"Ок"
                                                                                        okButton:nil];
        messageBox.delegate = self;
        [self.navigationController.tabBarController.view addSubview:messageBox.view];
    }
    else if ([emailTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""] || [nameTextField.text isEqualToString:@""])
    {
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                        bundle:nil
                                                                                        title:nil
                                                                                        message:@"Не все поля заполнены!"
                                                                                        cancelButton:@"Ок"
                                                                                        okButton:nil];
        messageBox.delegate = self;
        [self.navigationController.tabBarController.view addSubview:messageBox.view];
    }
    else
    {
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 331)];
        indicatorView.backgroundColor = [UIColor blackColor];
        indicatorView.alpha = 0.5f;
        UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                     240 - indicator.frame.size.height / 2.0f,
                                     indicator.frame.size.width,
                                     indicator.frame.size.height);
        
        [indicatorView addSubview:indicator];
        [indicator startAnimating];
        [self.navigationController.tabBarController.view addSubview:indicatorView];
        
        PFUser *user = [PFUser user];
        user.username = [Common getInstance].email;
        user.password = [Common getInstance].password;
        user.email = [Common getInstance].email;
        
        [user setObject:[Common getInstance].sex forKey:@"Sex"];
        [user setObject:[Common getInstance].bloodGroup forKey:@"BloodGroup"];
        [user setObject:[Common getInstance].bloodRH forKey:@"BloodRh"];
        [user setObject:[Common getInstance].name forKey:@"Name"];
 
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                [indicatorView removeFromSuperview];
                [indicatorView release];
                
                MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                                  bundle:nil
                                                                                                   title:nil
                                                                                                 message:@"Регистрация завершена"
                                                                                            cancelButton:@"Ок"
                                                                                                okButton:nil];
                messageBox.delegate = self;
                [self.navigationController.tabBarController.view addSubview:messageBox.view];
            }
            else
            {
                NSString *errorString;
                NSInteger errorCode = [[[error userInfo] objectForKey:@"code"] intValue];
                
                if (errorCode == 100)
                    errorString = @"Отсутсвует соединение с интернетом";
                else if (errorCode == 125)
                    errorString = @"Неправильный Email";
                else if (errorCode == 202)
                    errorString = @"Такой Email уже зарегистрирован";
                else
                    errorString = @"Ошибка соединения с сервером";
                
                MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                                  bundle:nil
                                                                                                   title:nil
                                                                                                 message:errorString
                                                                                            cancelButton:@"Ок"
                                                                                                okButton:nil];
                messageBox.delegate = self;
                [self.navigationController.tabBarController.view addSubview:messageBox.view];
                [indicatorView removeFromSuperview];
                [indicatorView release];
            }
        }];
    }    
}

- (IBAction)sexButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [self showModal:sexSelectViewController];
}

- (IBAction)bloodGroupButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [self showModal:selectBloodGroupViewController];
}

- (void) showModal:(UIViewController*) modalView
{
    UIWindow* mainWindow = (((AppDelegate*) [UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.view.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    modalView.view.center = offScreenCenter;
    [mainWindow addSubview:modalView.view];
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    modalView.view.center = middleCenter;
    [UIView commitAnimations];
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    
    if (modalView == selectBloodGroupViewController)
    {
        dataView.center = CGPointMake(dataView.center.x, dataView.center.y - 138);
    }
    else
        dataView.center = CGPointMake(dataView.center.x, dataView.center.y - 35);
    
    [UIView commitAnimations];
}

#pragma  mark MessageBoxDelegate

- (void)messageBoxResult:(BOOL)result controller:(MessageBoxViewController *)controller message:(NSString *)message
{
    if ([message isEqualToString:@"Регистрация завершена"])
    {
        [PFUser logOut];
        [PFUser logInWithUsername:emailTextField.text password:passwordTextField.text];
        [PFUser logInWithUsernameInBackground:emailTextField.text password:passwordTextField.text block:^(PFUser *user, NSError *error)
        {
            if (!error)
            {
                ProfileDescriptionViewController *controller = [[[ProfileDescriptionViewController alloc] initWithNibName:@"ProfileDescriptionViewController" bundle:nil] autorelease];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                                  bundle:nil
                                                                                                   title:nil
                                                                                                 message:@"Ошибка при авторизации"
                                                                                            cancelButton:@"Ок"
                                                                                                okButton:nil];
                messageBox.delegate = self;
                [self.view addSubview:messageBox.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    [controller release];
    
}

#pragma mark SelectBloodGroupDelegate

- (void) bloodGroupChanged:(NSString *)bloodGroup
{
    if (bloodGroup) 
    {
        [bloodGroupButton setTitle:bloodGroup forState:UIControlStateNormal];
        [bloodGroupButton setTitle:bloodGroup forState:UIControlStateHighlighted];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    dataView.center = CGPointMake(dataView.center.x, dataView.center.y + 138);
    [UIView commitAnimations];   
}

#pragma mark ProfileSexSelectDelegate

- (void) sexChanged:(NSString *)selectedSex
{
    if (selectedSex) 
    {
        if ([selectedSex isEqualToString:@"Мужской"])
        {
            [sexButton setTitle:@"муж" forState:UIControlStateNormal];
            [sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
        }
        else
        {
            [sexButton setTitle:@"жен" forState:UIControlStateNormal];
            [sexButton setTitle:@"жен" forState:UIControlStateHighlighted];
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    dataView.center = CGPointMake(dataView.center.x, dataView.center.y + 35);
    [UIView commitAnimations];   
}

#pragma mark TextEditDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
        [Common getInstance].email = textField.text;
    else if (textField.tag == 2)
        [Common getInstance].password = textField.text;
    else if (textField.tag == 4)
    {
        if (textField.text)
            [Common getInstance].name = textField.text;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        
        dataView.center = CGPointMake(dataView.center.x, dataView.center.y + 65);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 4)
    {   
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];

        dataView.center = CGPointMake(dataView.center.x, dataView.center.y - 65);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    NSLog(@"%@",textField.text);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Регистрация";
    
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect cancelButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [cancelButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    cancelButton.frame = cancelButtonFrame;
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
    [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect doneButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [doneButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [doneButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Готово" forState:UIControlStateNormal];
    [doneButton setTitle:@"Готово" forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    doneButton.frame = doneButtonFrame;
    [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    
    selectBloodGroupViewController = [[SelectBloodGroupViewController alloc] init];
    selectBloodGroupViewController.delegate = self;
    sexSelectViewController = [[ProfileSexSelectViewController alloc] init];
    sexSelectViewController.delegate = self;
    [bloodGroupButton setTitle:@"O(I)RH+" forState:UIControlStateNormal];
    [bloodGroupButton setTitle:@"O(I)RH+" forState:UIControlStateHighlighted];
    [sexButton setTitle:@"муж" forState:UIControlStateNormal];
    [sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
  
    //Приватное свойство!
    [nameTextField setValue:[UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [emailTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordConfirmTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
   
    [Common getInstance].bloodGroup = [NSNumber numberWithInt:0];
    [Common getInstance].bloodRH = [NSNumber numberWithInt:0];
    [Common getInstance].sex = [NSNumber numberWithInt:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [selectBloodGroupViewController release];
    [super dealloc];
}

@end
