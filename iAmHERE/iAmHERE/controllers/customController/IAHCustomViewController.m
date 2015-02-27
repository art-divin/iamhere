//
//  IAHCustomViewController.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHCustomViewController.h"
#import "IAHTheme.h"

@interface IAHCustomViewController ()

@end

@implementation IAHCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[IAHTheme colorForViewBackground]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
