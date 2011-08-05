//
//  HPTextView.m
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

#import "HPGrowingTextView.h"
#import "HPTextViewInternal.h"


@implementation HPGrowingTextView
@synthesize internalTextView;
@synthesize maxNumberOfLines;
@synthesize minNumberOfLines;
@synthesize delegate;

@synthesize text;
@synthesize font;
@synthesize textColor;
@synthesize textAlignment; 
@synthesize selectedRange;
@synthesize editable;
@synthesize dataDetectorTypes; 
@synthesize animateHeightChange;
@synthesize returnKeyType;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		CGRect r = frame;
		r.origin.y = 0;
		r.origin.x = 0;
		
		internalTextView = [[HPTextViewInternal alloc] initWithFrame:r];
		internalTextView.delegate = self;
		internalTextView.scrollEnabled = NO;
		internalTextView.font = [UIFont fontWithName:@"Helvetica" size:13]; 
		internalTextView.contentInset = UIEdgeInsetsZero;		
		internalTextView.showsHorizontalScrollIndicator = NO;
		internalTextView.text = @"-";
		[self addSubview:internalTextView];
		
		UIView *internal = (UIView*)[[internalTextView subviews] objectAtIndex:0];
		minHeight = internal.frame.size.height;
		minNumberOfLines = 1;
		
		animateHeightChange = YES;
		
		internalTextView.text = @"";
		
		[self setMaxNumberOfLines:3];
    }
    return self;
}

-(void)sizeToFit
{
	CGRect r = self.frame;
	r.size.height = minHeight;
	self.frame = r;
}

-(void)setFrame:(CGRect)aframe
{
	CGRect r = aframe;
	r.origin.y = 0;
	r.origin.x = 0;
	internalTextView.frame = r;
	
	[super setFrame:aframe];
}

-(void)setMaxNumberOfLines:(int)n
{
	UITextView *test = [[HPTextViewInternal alloc] init];	
	test.font = internalTextView.font;
	test.hidden = YES;
	
	NSMutableString *newLines = [NSMutableString string];
	
	if(n == 1){
		[newLines appendString:@"-"];
	} else {
		for(int i = 1; i<n; i++){
			[newLines appendString:@"\n"];
		}
	}
	
	test.text = newLines;
	
	
	[self addSubview:test];

	maxHeight = test.contentSize.height;
	maxNumberOfLines = n;
	
	[test removeFromSuperview];
	[test release];	
}

-(void)setMinNumberOfLines:(int)m
{
	
	UITextView *test = [[HPTextViewInternal alloc] init];	
	test.font = internalTextView.font;
	test.hidden = YES;
	
	NSMutableString *newLines = [NSMutableString string];
 
	if(m == 1){
		[newLines appendString:@"-"];
	} else {
		for(int i = 1; i<m; i++){
			[newLines appendString:@"\n"];
		}
	}
	
	test.text = newLines;
	
	
	[self addSubview:test];
	
	minHeight = test.contentSize.height;
			
	[self sizeToFit];	
	minNumberOfLines = m;
	
	[test removeFromSuperview];
	[test release];
}


- (void)textViewDidChange:(UITextView *)textView
{
	//size of content, so we can set the frame of self
	NSInteger newSizeH = internalTextView.contentSize.height;
	if(newSizeH < minHeight || !internalTextView.hasText) newSizeH = minHeight; //not smalles than minHeight
	 
	if (internalTextView.frame.size.height != newSizeH)
	{
		if (newSizeH <= maxHeight)
		{
			if(animateHeightChange){
				[UIView beginAnimations:@"" context:nil];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(growDidStop)];
				[UIView setAnimationBeginsFromCurrentState:YES];
			}
			
			if ([delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)]) {
				[delegate growingTextView:self willChangeHeight:newSizeH];
			}
			
			// internalTextView
			CGRect internalTextViewFrame = self.frame;
			internalTextViewFrame.size.height = newSizeH; // + padding
			self.frame = internalTextViewFrame;
			
			internalTextViewFrame.origin.y = 0;
			internalTextViewFrame.origin.x = 0;
			internalTextView.frame = internalTextViewFrame;
			
			if(animateHeightChange){
				[UIView commitAnimations];
			}			
		}
		
				
        // if our new height is greater than the maxHeight
        // sets not set the height or move things
        // around and enable scrolling
		if (newSizeH >= maxHeight)
		{
			if(!internalTextView.scrollEnabled){
				internalTextView.scrollEnabled = YES;
				[internalTextView flashScrollIndicators];
			}
			
		} else {
			internalTextView.scrollEnabled = NO;
		}
		
	}
	
	
	if ([delegate respondsToSelector:@selector(growingTextViewDidChange:)]) {
		[delegate growingTextViewDidChange:self];
	}
	
}

-(void)growDidStop
{
	if ([delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
		[delegate growingTextView:self didChangeHeight:self.frame.size.height];
	}
	
}

-(BOOL)resignFirstResponder
{
	[super resignFirstResponder];
	return [internalTextView resignFirstResponder];
}

- (void)dealloc {
	[internalTextView release];
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITextView properties
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setText:(NSString *)atext
{
	internalTextView.text= atext;
}
//
-(NSString*)text
{
	return internalTextView.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setFont:(UIFont *)afont
{
	internalTextView.font= afont;
	
	[self setMaxNumberOfLines:maxNumberOfLines];
	[self setMinNumberOfLines:minNumberOfLines];
}

-(UIFont *)font
{
	return internalTextView.font;
}	

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextColor:(UIColor *)color
{
	internalTextView.textColor = color;
}

-(UIColor*)textColor{
	return internalTextView.textColor;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextAlignment:(UITextAlignment)aligment
{
	internalTextView.textAlignment = aligment;
}

-(UITextAlignment)textAlignment
{
	return internalTextView.textAlignment;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setSelectedRange:(NSRange)range
{
	internalTextView.selectedRange = range;
}

-(NSRange)selectedRange
{
	return internalTextView.selectedRange;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setEditable:(BOOL)beditable
{
	internalTextView.editable = beditable;
}

-(BOOL)isEditable
{
	return internalTextView.editable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
	internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
	return internalTextView.returnKeyType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setDataDetectorTypes:(UIDataDetectorTypes)datadetector
{
	internalTextView.dataDetectorTypes = datadetector;
}

-(UIDataDetectorTypes)dataDetectorTypes
{
	return internalTextView.dataDetectorTypes;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)hasText{
	return [internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range
{
	[internalTextView scrollRangeToVisible:range];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
		return [delegate growingTextViewShouldBeginEditing:self];
		
	} else {
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewShouldEndEditing:)]) {
		return [delegate growingTextViewShouldEndEditing:self];
		
	} else {
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewDidBeginEditing:)]) {
		[delegate growingTextViewDidBeginEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView {		
	if ([delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
		[delegate growingTextViewDidEndEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
	replacementText:(NSString *)atext {
	
	//weird 1 pixel bug when clicking backspace when textView is empty
	if(![textView hasText] && [atext isEqualToString:@""]) return NO;
	
	if ([atext isEqualToString:@"\n"]) {
		if ([delegate respondsToSelector:@selector(growingTextViewShouldReturn:)]) {
			if (![delegate performSelector:@selector(growingTextViewShouldReturn:) withObject:self]) {
				return YES;
			} else {
				[textView resignFirstResponder];
				return NO;
			}
		}
	}
	
	return YES;
	

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChangeSelection:(UITextView *)textView {
	if ([delegate respondsToSelector:@selector(growingTextViewDidChangeSelection:)]) {
		[delegate growingTextViewDidChangeSelection:self];
	}
}

@end
