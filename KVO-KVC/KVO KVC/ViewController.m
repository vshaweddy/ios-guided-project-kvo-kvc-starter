//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee * philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000;
    marketing.manager = philSchiller;

    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];

    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
//    NSLog(@"%@", self.hrController);
    
    
    // Key Value Coding: KVC
    // * Core Data
    // * Cocoa Bindings (UI + Model = SwiftUI)
    
    // @property NSString *name;
    
    // 1. Accessor for a property
        // - (NSString *)name;
    // 2. Setter for a property
        // - (void)setName:(NSString *)name;
    // 3. Instance variable to set
    
    // Modify our Data using the self.name syntax (not _name)
    // 1. init/dealloc always use: _name =
    // 2. Normal methods always use: self.name =
    
    // Property accessor (method call or the property dot syntax
    NSString *name = [craig name]; // craign.name; // compile time checking for valid properties
    NSLog(@"Name: %@", name);
    
    // Dynamic method call - look up methods and call them via a NSString name
    // NSString *name2 = [craig valueForKey:@"firstName"]; // No build issues, CRASHES at runtime!
    NSString *name2 = [craig valueForKey:@"privateName"]; // No build issues, accesses a private property
//    NSString *name2 = [craig valueForKey:@"name"];
    NSLog(@"Name: %@", name2);
    
    [craig setValue:@"Bob" forKey:@"name"];
    NSLog(@"Name change: %@", craig.name); // craig.name (property accessor)
    
    // 1. Spelling is very important when using keys (Crash at runtime)
    // 2. Types must match or it'll crash
    
    [craig setValue:@42 forKey:@"name"]; // Converted NSNumber to NSString and set it
    NSLog(@"Name change: %@", craig.name);
    
    // Collections and Keypaths
    
//    NSLog(@"Departments1: %@", [[self hrController] departments]); // method calling
//    NSLog(@"Departments2: %@", self.hrController.departments); // dot syntax
    
    // keypath: departments
    
    NSLog(@"Departments3a: %@", [self.hrController valueForKeyPath:@"departments"]); // dot syntax
    NSLog(@"Departments3b: %@", [self.hrController valueForKey:@"departments"]); // this works with valueForKey because it doesn't go deeper
    
    // Traversing the objects (going deeper)
    NSLog(@"Department Name: %@", [self.hrController valueForKeyPath:@"departments.name"]); // dot syntax
//    NSLog(@"Department Name: %@", [self.hrController valueForKey:@"departments.name"]); // CRASH because it can't drill down to the name using valueForKey
    
    // like a .map to aggregate all the department employee arrays into a big array of arrays
    // [[Employee]]
    NSLog(@"Department Employees: %@", [self.hrController valueForKeyPath:@"departments.employees"]);
    
    // Collection Operators
    // Goal: [Employee]
    // @distinctUnionOfArrays = unique values
    NSLog(@"Department Employees: %@", [self.hrController valueForKeyPath:@"departments.@distinctUnionOfArrays.employees"]);
    
    NSArray<LSIEmployee *> *allEmployees = [self.hrController valueForKeyPath:@"departments.@distinctUnionOfArrays.employees"];
    NSLog(@"Department Employees: %@", allEmployees);
    
    NSLog(@"Salaries: %@", [allEmployees valueForKeyPath:@"salary"]);
    NSLog(@"Max Salary: %@", [allEmployees valueForKeyPath:@"@max.salary"]);
    
    // Print another collection opeartor on the allEmployees
    NSLog(@"Avg Salary: %@", [allEmployees valueForKeyPath:@"@avg.salary"]);
    NSLog(@"Count Salaries: %@", [allEmployees valueForKeyPath:@"@count.salary"]);
    
    // Count the number of employees
    NSLog(@"Count Employees: %@", [allEmployees valueForKeyPath:@"@count"]);
}


@end
