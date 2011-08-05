//
//  GrowingTextViewExampleViewController.m
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "GrowingTextViewExampleViewController.h"

@implementation GrowingTextViewExampleViewController


-(id)init
{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification 
												   object:nil];		
	}
	
	return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor grayColor];
	
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 4;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont boldSystemFontOfSize:15.0f];
	textView.delegate = self;
	//textView.animateHeightChange = NO; //turns off animation
		
	[self.view addSubview:textView];
	[textView sizeToFit];
	
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	doneBtn.frame = CGRectMake(30, 30, 260, 80);
	[doneBtn setTitle:@"Done" forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:doneBtn];
		
	CGRect r = textView.frame;
	r.origin.y = self.view.frame.size.height - r.size.height;
	textView.frame = r;		
}

-(void)resignTextView
{
	NSLog(@"???");
	[textView resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
	
	// get the height since this is the main value that we need.
	NSInteger kbSizeH = keyboardBounds.size.height;
		
	// get a rect for the textView frame
	CGRect textViewFrame = textView.frame;
	textViewFrame.origin.y -= kbSizeH;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
	// set views with new info
	textView.frame = textViewFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    // get keyboard size and location
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
	
	// get the height since this is the main value that we need.
	NSInteger kbSizeH = keyboardBounds.size.height;
	
	// get a rect for the textView frame
	CGRect textViewFrame = textView.frame;
	textViewFrame.origin.y += kbSizeH;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
	// set views with new info
	textView.frame = textViewFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
	float diff = (textView.frame.size.height - height);
		
	CGRect r = textView.frame;
	r.origin.y += diff;
	textView.frame = r;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textView release];
    [super dealloc];
}

@end
