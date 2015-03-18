//
//  LFSettingsViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 04/03/2015.
//
//

#import "LFSettingsViewController.h"

@interface LFSettingsViewController ()

@end

@implementation LFSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end