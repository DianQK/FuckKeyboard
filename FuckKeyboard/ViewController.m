//
//  ViewController.m
//  FuckKeyboard
//
//  Created by 宋宋 on 15/8/1.
//  Copyright (c) 2015年 dianqk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *textContentView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic) NSLayoutConstraint *bottomConstraint;
@property (nonatomic) NSLayoutConstraint *widthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 5.0;
    self.textContentView.layer.cornerRadius = 5.0;
    self.iconImageView.layer.cornerRadius = 10.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.usernameTextField isExclusiveTouch]) {
        [self.usernameTextField resignFirstResponder];
    }
    if (![self.passwordTextField isExclusiveTouch]) {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSValue *value = [userInfo objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = value.CGRectValue.size.height;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        [self updateViewConstraintsForKeyboardHeight:keyboardHeight];
    }];
    
}

- (void)keyboardWillHidden:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        [self updateViewConstraintsForKeyboardHeight:0];
    }];
    
}

- (void)updateViewConstraintsForKeyboardHeight:(CGFloat)keyboardHeight {
    if (_bottomConstraint) {
        [self.view removeConstraints:@[_bottomConstraint,_widthConstraint]];
        _bottomConstraint = nil;
        _widthConstraint = nil;
    }
    if (keyboardHeight) {
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.loginButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:keyboardHeight + 10];
        _widthConstraint = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        [self.view addConstraints:@[_bottomConstraint,_widthConstraint]];
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
