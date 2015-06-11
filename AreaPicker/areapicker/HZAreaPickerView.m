//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Damocs Yang on 15-6-11.
//  Copyright (c) 2015年 damocs.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
}

@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize datasource=_datasource;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;

- (void)dealloc
{
    self.datasource = nil;
    self.delegate = nil;
}

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle withDelegate:(id <HZAreaPickerDelegate>)delegate andDatasource:(id <HZAreaPickerDatasource>)datasource
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.datasource = datasource;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        provinces = [self.datasource areaPickerData:self] ;
        
        cities = [[provinces objectAtIndex:0] objectForKey:@"city"];
        
        if (![cities isKindOfClass:[NSArray class]])
        {
            cities = [[NSArray alloc]initWithObjects:cities,nil];
        }
        
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"name"];
        
        if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
        {
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"name"];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"district"];
            
            if (![areas isKindOfClass:[NSArray class]])
            {
                areas = [[NSArray alloc]initWithObjects:areas,nil];
            }
            
            if (areas.count > 0)
            {
                self.locate.district = [[areas objectAtIndex:0] objectForKey:@"name"];
            }
            else
            {
                self.locate.district = @"";
            }
            
        } else{
            self.locate.city = [[cities objectAtIndex:0]objectForKey:@"name"];
        }
    }
        
    return self;
    
}



#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component)
        {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"name"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"name"];
                break;
            case 2:
                if ([areas count] > 0) {
                    return [[areas objectAtIndex:row] objectForKey:@"name"];
                    break;
                }
            default:
                return  @"";
                break;
        }
    } else{
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"name"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"name"];
                break;
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        switch (component)
        {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"city"];
                
                if (![cities isKindOfClass:[NSArray class]])
                {
                    cities = [[NSArray alloc]initWithObjects:cities,nil];
                }
                
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"district"];
                
                if (![areas isKindOfClass:[NSArray class]])
                {
                    areas = [[NSArray alloc]initWithObjects:areas,nil];
                }
                
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"name"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"name"];
                if ([areas count] > 0)
                {
                    self.locate.district = [[areas objectAtIndex:0] objectForKey:@"name"];
                }
                else{
                    self.locate.district = @"其他";
                }
                break;
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"district"];
                
                if (![areas isKindOfClass:[NSArray class]])
                {
                    areas = [[NSArray alloc]initWithObjects:areas,nil];
                }
                
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"name"];
                if ([areas count] > 0) {
                    self.locate.district = [[areas objectAtIndex:0] objectForKey:@"name"];
                } else{
                    self.locate.district = @"其他";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = [[areas objectAtIndex:row] objectForKey:@"name"];
                } else{
                    self.locate.district = @"其他";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"city"];
                
                if (![cities isKindOfClass:[NSArray class]])
                {
                    cities = [[NSArray alloc]initWithObjects:cities,nil];
                }
                
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"name"];
                self.locate.city = [[cities objectAtIndex:0]objectForKey:@"name"];
                break;
            case 1:
                self.locate.city = [[cities objectAtIndex:row]objectForKey:@"name"];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }

}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
