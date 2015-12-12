//
//  IPOListViewController.m
//  stock
//
//  Created by Daniel Kong on 11/19/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "IPOListViewController.h"
#import "TFHpple.h"
#import "IPOModel.h"
#import "IPOListTableViewCell.h"
#import "SRMonthPicker.h"

#import "UIImageView+AFNetworking.h"

#import "DKNightVersion.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


static NSString *kStyledActiveCellIdentifier = @"IPOListCell";
#define TICK    NSDate *methodStart = [NSDate date];
#define TOCK    NSLog(@"executionTime = %f", [[NSDate date] timeIntervalSinceDate:methodStart]);

@interface IPOListViewController () <UITableViewDataSource, UITableViewDelegate, SRMonthPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) SRMonthPicker *monthPicker;
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITableView *IPOtableView;
@property (nonatomic, copy) NSArray *rows;
@property (nonatomic, copy) NSMutableArray *IPOModelList;
@property (nonatomic, copy) NSArray *sortedArray;
@property (nonatomic, assign, getter=isSortedByCap) BOOL sortedByCap;

@property (nonatomic, strong) UIPickerView *ipoTypePickerView;
@property (nonatomic, strong) UITextField *ipoTypeField;

@property (nonatomic, copy) NSArray *tableViewRows;

@end

@implementation IPOListViewController

- (void)loadView {
    [super loadView];
    //    self.refreshButton = [[UIButton alloc] init];
    //    [self.view addSubview:self.refreshButton];
    self.ipoTypeField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.ipoTypeField.borderStyle = UITextBorderStyleRoundedRect;
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM"]; //@"dd/MMM/YYYY hh:min a"];
    self.ipoTypeField.placeholder = @"upcoming"; //[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    [self.view addSubview:self.ipoTypeField];
    
    self.dateField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.dateField.borderStyle = UITextBorderStyleRoundedRect;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM"]; //@"dd/MMM/YYYY hh:min a"];
    self.dateField.placeholder = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    [self.view addSubview:self.dateField];
    
    self.IPOtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.IPOtableView.delegate = self;
    self.IPOtableView.dataSource = self;
    self.IPOtableView.separatorColor = [UIColor lightGrayColor];
    self.IPOtableView.separatorInset = UIEdgeInsetsMake(0, -7, 0, 0);
    self.IPOtableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.IPOtableView registerClass:[IPOListTableViewCell class] forCellReuseIdentifier:kStyledActiveCellIdentifier];
    
    // iOS 8 or later
    self.IPOtableView.rowHeight = UITableViewAutomaticDimension;
    self.IPOtableView.estimatedRowHeight = 64;
    //    self.ERtableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.IPOtableView];
    
    //
    _sortedByCap = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    UIView *statusBarView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:statusBarView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ipoTypeField.frame = CGRectMake(0, rect.size.height, self.view.bounds.size.width * 1/4, 44);
    self.ipoTypePickerView = [[UIPickerView alloc] init];
    self.ipoTypePickerView.delegate = self;
    self.ipoTypePickerView.dataSource = self;
    [self.ipoTypeField setInputView:_ipoTypePickerView];
    
    self.dateField.frame = CGRectMake(self.view.bounds.size.width * 1/4 + 10, rect.size.height, self.view.bounds.size.width, 44);
    self.monthPicker = [[SRMonthPicker alloc] init];
    // I will be using the delegate here
    self.monthPicker.monthPickerDelegate = self;
    // Some options to play around with
    self.monthPicker.maximumYear = 2020;
    self.monthPicker.minimumYear = 1900;
    self.monthPicker.yearFirst = YES;
    [self.dateField setInputView:_monthPicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn, space, doneBtn, nil]];
    [self.dateField setInputAccessoryView:toolBar];
    self.IPOtableView.frame = CGRectMake(0, rect.size.height + 44, self.view.bounds.size.width, self.view.bounds.size.height - statusBarView.frame.size.height - self.dateField.frame.size.height);
    // inset just make it show down 20, but when scroll it, cell could scroll to 0.
    self.IPOtableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 49.0f, 0.0f);
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        self.view.normalBackgroundColor = [UIColor whiteColor];
        self.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.IPOtableView.normalBackgroundColor = [UIColor whiteColor];
        self.IPOtableView.nightBackgroundColor = UIColorFromRGB(0x343434);
//        button.normalTitleColor = [UIColor blueColor];
//        button.nightTitleColor = [UIColor whiteColor];
//        switchButton.normalTitleColor = [UIColor blueColor];
//        switchButton.nightTitleColor = [UIColor whiteColor];
    }];
    
    // fetch and show datay
    [self reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - public
- (void)reloadData {
    [self fetchDataWithDate:self.dateField.text == nil?self.dateField.placeholder : self.dateField.text IPOType:[_ipoTypeField.text isEqualToString:@""]?_ipoTypeField.placeholder : _ipoTypeField.text];
}

# pragma mark - private

- (void)fetchDataWithDate:(NSString *)date IPOType:(NSString *)ipoType{
    NSURLSession *session = [NSURLSession sharedSession];
    
    // http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=2015-Oct-21
    // @"https://itunes.apple.com/search?term=apple&media=software"
    // http://chuansong.me/account/bigcompany007
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.nasdaq.com/markets/ipos/activity.aspx?tab=%@&month=%@", ipoType, date];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedFailureReason] message:[error localizedRecoverySuggestion] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
        NSString *queryString = @"//div[@class='genTable']";
        NSArray *elements  = [doc searchWithXPathQuery:queryString];
        
        // handle no earning report day (elements == 0)
        if ([elements count] != 0) {
            NSArray *arr = [elements[0] searchWithXPathQuery:@"//tr"];  // arr how many ER on this day.
            self.rows = arr;
        } else {
            self.rows = nil;
        }
        
        //convert raw data to model
        
        _IPOModelList = [NSMutableArray array];
        for (TFHppleElement *element in _rows) {
            IPOModel *ipoModel = [[IPOModel alloc] initWithHTMLTFHppleElement:element];
            // first item is row of title
            [_IPOModelList addObject:ipoModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.IPOtableView reloadData];
        });
        
        _sortedArray = [[NSArray alloc] init];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            //            NSArray *sortedArray;
//            _sortedArray = [_IPOModelList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//                NSString *first = [(IPOModel*)a market];
//                NSString *second = [(IPOModel*)b market];
//                // p, M, B, a
//                
//                NSString *firstSymbol = [first substringFromIndex: [first length] - 1];
//                NSString *secondSymbol = [second substringFromIndex: [second length] - 1];
//                NSString *firstNumber = [first substringFromIndex: 1];
//                NSString *secondNumber = [second substringFromIndex: 1];
//                
//                if ( [firstSymbol isEqualToString:@"p"] || [secondSymbol isEqualToString:@"p"]) {
//                    return NSOrderedAscending;
//                } else {
//                    if ([firstSymbol isEqualToString:secondSymbol]) {
//                        return [firstNumber floatValue] < [secondNumber floatValue];
//                    }
//                    return [firstSymbol compare:secondSymbol];
//                }
//            }];
//        });
        
        // Invalidate Session
        [session finishTasksAndInvalidate];
    }];
    
    [dataTask resume];
}

# pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortedByCap?[self.sortedArray count]:[self.IPOModelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IPOListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[IPOListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    IPOModel *modelItem = _sortedByCap?[self.sortedArray objectAtIndex:indexPath.row]:[self.IPOModelList objectAtIndex:indexPath.row];
    
    cell.leftTitle.text = modelItem.NASDAQSymbol;
    [cell.leftTitle sizeToFit];
    
    cell.titleLabel.text = modelItem.name;
    cell.rightTitle.text = modelItem.price;
    cell.rightSubTitle.text = modelItem.expectedIPODate;
    cell.subTitle.text = modelItem.offerAmount;
    
//    //     scroll cell cause lag, do it async, or using SDWebImage
//    ////     http://stackoverflow.com/questions/14579079/slow-loading-the-images-from-url-in-uitableview
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //        cell.subImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.nasdaq.com//charts/%@_smallrm.jpeg",modelItem.NASDAQSymbol]]]];
//        [cell.subImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.nasdaq.com//charts/%@_smallrm.jpeg",modelItem.NASDAQSymbol]] placeholderImage:nil];
//        // TODO: change image background to clearColor
//        //        cell.subImageView.image = [yourImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        
//    });
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        cell.toggle.hidden = NO;
//        cell.toggle.on = _sortedByCap;
//        cell.toggleText.hidden = NO;
//    } else {
//        
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 85.0;
//}

# pragma mark - date text field

- (void)ShowSelectedDate {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM"]; //@"dd/MMM/YYYY hh:min a"];
    self.dateField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:_monthPicker.date]];
    [self.dateField resignFirstResponder];
    
    // update tableview based on selected date
    [self fetchDataWithDate:self.dateField.text IPOType:[_ipoTypeField.text isEqualToString:@""]?_ipoTypeField.placeholder : _ipoTypeField.text];
}

- (void)cancel {
    [self.dateField resignFirstResponder];
}

# pragma mark - EarningTableViewCellDelegate

- (void)reloadEarningTableView:(IPOListTableViewCell *)cell {
    NSLog(@"successfully to table view controller from cell");
    self.IPOModelList = [_sortedArray mutableCopy];
    _sortedByCap = YES;
    [self.IPOtableView reloadData];
}

-(void)reloadEarningTableViewBySwitch:(id)sender {
    UISwitch *onoff = (UISwitch *)sender;
    if (onoff.on) {
        _sortedByCap = YES;
    } else {
        _sortedByCap = NO;
    }
    [self.IPOtableView reloadData];
}

# pragma mark - date picker

- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker
{
    // Show the date is changing (with a 1 second wait mimicked)
    self.dateField.text = [NSString stringWithFormat:@"%@", [self formatDate:monthPicker.date]];
}

- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
    dispatch_queue_t delayQueue = dispatch_queue_create("com.simonrice.SRMonthPickerExample.DelayQueue", 0);
    
    dispatch_async(delayQueue, ^{
        // Wait 1 second
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateField.text = [NSString stringWithFormat:@"%@", [self formatDate:self.monthPicker.date]];
        });
    });
    
}

- (NSString*)formatDate:(NSDate *)date
{
    // A convenience method that formats the date in Year-Month format
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM";
    return [formatter stringFromDate:date];
}

# pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

# pragma mark - UIPickerViewDelegate

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED;
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED;

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0)
        return @"upcoming";
    else if (row == 1)
        return @"pricings";
    else if (row == 2)
        return @"filings";
    return @"";
}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; // attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _ipoTypePickerView) {
        if (row == 0) {
            _ipoTypeField.text = @"upcoming";
        } else if (row == 1) {
            _ipoTypeField.text = @"pricings";
        } else if (row == 2) {
            _ipoTypeField.text = @"filings";
        }
        
        [_ipoTypeField resignFirstResponder];
        [self reloadData];
    }
}

@end
