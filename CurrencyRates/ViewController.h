//
//  ViewController.h
//  CurrencyRates
//
//  Created by Evgeny Zakharov on 3/9/16.
//  Copyright © 2016 Evgeny Zakharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;


@property (copy, nonatomic) NSMutableArray *arResult;


@end

