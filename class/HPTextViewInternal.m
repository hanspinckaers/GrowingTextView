//
//  HPTextViewInternal.m
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

#import "HPTextViewInternal.h"


@interface HPTextViewInternal ()
{
    BOOL _editActionCallInProgress;
}

@end

@implementation HPTextViewInternal

-(void)setText:(NSString *)text
{
    BOOL originalValue = self.scrollEnabled;
    //If one of GrowingTextView's superviews is a scrollView, and self.scrollEnabled == NO,
    //setting the text programatically will cause UIKit to search upwards until it finds a scrollView with scrollEnabled==yes
    //then scroll it erratically. Setting scrollEnabled temporarily to YES prevents this.
    [self setScrollEnabled:YES];
    [super setText:text];
    [self setScrollEnabled:originalValue];
}

- (void)setScrollable:(BOOL)isScrollable
{
    [super setScrollEnabled:isScrollable];
}

-(void)setContentOffset:(CGPoint)s
{
	if(self.tracking || self.decelerating){
		//initiated by user...
        
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
        
	} else {

		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomOffset && self.scrollEnabled){            
            UIEdgeInsets insets = self.contentInset;
            insets.bottom = 8;
            insets.top = 0;
            self.contentInset = insets;            
        }
	}
    
    // Fix "overscrolling" bug
    if (s.y > self.contentSize.height - self.frame.size.height && !self.decelerating && !self.tracking && !self.dragging)
        s = CGPointMake(s.x, self.contentSize.height - self.frame.size.height);
    
	[super setContentOffset:s];
}

-(void)setContentInset:(UIEdgeInsets)s
{
	UIEdgeInsets insets = s;
	
	if(s.bottom>8) insets.bottom = 0;
	insets.top = 0;

	[super setContentInset:insets];
}

-(void)setContentSize:(CGSize)contentSize
{
    // is this an iOS5 bug? Need testing!
    if(self.contentSize.height > contentSize.height)
    {
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
    }
    
    [super setContentSize:contentSize];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.displayPlaceHolder && self.placeholder && self.placeholderColor)
    {
        if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = self.textAlignment;
            [self.placeholder drawInRect:CGRectMake(5, 8 + self.contentInset.top, self.frame.size.width-self.contentInset.left, self.frame.size.height- self.contentInset.top) withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.placeholderColor, NSParagraphStyleAttributeName:paragraphStyle}];
        }
        else {
            [self.placeholderColor set];
            [self.placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withFont:self.font];
        }
    }
}

-(void)setPlaceholder:(NSString *)placeholder
{
	_placeholder = placeholder;
	
	[self setNeedsDisplay];
}


#pragma mark - copy/paste delegation support


// The following code allows you to to override the copy/paste functionality by subclassing HPGrowingTextView.
// In your subclass you may override canPerformAction:withSender as well implement any of the UIResponderEditAction
// informal protocol methods. You may safely call the methods in self.internalTextView to get the default implementation.


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks" // yes, we know, but it's ok


-(BOOL)delegatePerformEditAction:(SEL)sel sender:(id)sender
{
    if ( !_editActionCallInProgress && [self.delegate respondsToSelector:sel] )
    {
        _editActionCallInProgress = YES;
        [self.delegate performSelector:sel withObject:sender];
        _editActionCallInProgress = NO;
        return YES;  // handled
    }
    else
        return NO;  // not handled, call super
}


#pragma clang diagnostic pop


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( !_editActionCallInProgress )
    {
        _editActionCallInProgress = YES;
        BOOL result = [(id)self.delegate canPerformAction:action withSender:sender];
        _editActionCallInProgress = NO;
        
        return result;
    }
    else
        return [super canPerformAction:action withSender:sender];
}


-(void)copy:(id)sender
{
    if ( ![self delegatePerformEditAction:_cmd sender:sender] )
        [super copy:sender];
}


-(void)cut:(id)sender
{
    if ( ![self delegatePerformEditAction:_cmd sender:sender] )
        [super cut:sender];
}


-(void)paste:(id)sender
{
    if ( ![self delegatePerformEditAction:_cmd sender:sender] )
        [super paste:sender];
}


-(void)select:(id)sender
{
    if ( ![self delegatePerformEditAction:_cmd sender:sender] )
        [super select:sender];
}


-(void)selectAll:(id)sender
{
    if ( ![self delegatePerformEditAction:_cmd sender:sender] )
        [super selectAll:sender];
}


@end
