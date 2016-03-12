//
//  ViewController.m
//  CurrencyRates
//
//  Created by Evgeny Zakharov on 3/9/16.
//  Copyright © 2016 Evgeny Zakharov. All rights reserved.
//

#import "ViewController.h"

#import "libxml/HTMLParser.h"
#import "libxml/HTMLNode.h"
#import "libxml/HTMLParser.m"
#import "libxml/HTMLNode.m"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Main cell"];
    }
    NSLog(@"row: %@", self.arResult[indexPath.row]);
    cell.textLabel.text = self.arResult[indexPath.row];
    
    return cell;
}

- (IBAction)goButtonPressed:(id)sender {
    NSString *url = @"http://www.banki.ru/products/currency/cash/yaroslavl~/";
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *error = nil;

    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error: &error];
    if(error) {
        NSLog(@"Error: %@", error);
    }
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if(error) {
        NSLog(@"Error: %@", error);
    }

    NSMutableArray *bankNames = [[NSMutableArray alloc] init];
    NSMutableArray *usdValues = [[NSMutableArray alloc] init];
    NSMutableArray *arResultTemp = [[NSMutableArray alloc] init];
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *tableDiv = [bodyNode findChildOfClass:@"hor-not-fit-element"];
    NSArray *usdValueNodes = [tableDiv findChildrenWithAttribute:@"data-currencies-code" matchingName:@"usd" allowPartial:true];
    for(HTMLNode *val in usdValueNodes) {
        NSString *str = [val contents];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [usdValues addObject:str];
    }
    NSArray *bankNameNodes = [tableDiv findChildrenOfClass:@"font-bold"];
    for(HTMLNode *val in bankNameNodes) {
        NSString *str = [val contents];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [bankNames addObject:str];
    }
    
    int banksCount = [bankNames count];
    for(int i = 0; i < banksCount; i++) {
        NSString *item = [NSString stringWithFormat:@"%@ - %@", [bankNames objectAtIndex:i], [usdValues objectAtIndex:i]];
        [arResultTemp addObject:item];
        NSLog(@"Bank %@ USD = %@\n", [bankNames objectAtIndex:i], [usdValues objectAtIndex:i]);
    }
    self.arResult = arResultTemp;
    [self.resultTableView reloadData];
    
}

@end
