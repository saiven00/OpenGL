//
//  ViewController.m
//  正方体旋转-CoreAnimation
//
//  Created by Liushaoyi on 2020/8/2.
//  Copyright © 2020 Liushaoyi. All rights reserved.
//

#import "ViewController.h"


#import "AnimationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)jump:(id)sender {
    AnimationViewController *nexVC = [[AnimationViewController alloc] init];
    [self presentViewController:nexVC animated:YES completion:nil];
}

@end
