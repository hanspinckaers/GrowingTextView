//
//  HPTextView.h
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

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
	// UITextAlignment is deprecated in iOS 6.0+, use NSTextAlignment instead.
	// Reference: https://developer.apple.com/library/ios/documentation/uikit/reference/NSString_UIKit_Additions/Reference/Reference.html
	#define NSTextAlignment UITextAlignment
#endif

@class HPGrowingTextView;
@class HPTextViewInternal;

@protocol HPGrowingTextViewDelegate

@optional
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;
@end

@interface HPGrowingTextView : UIView <UITextViewDelegate> {
	HPTextViewInternal *internalTextView;	
	
	int minHeight;
	int maxHeight;
	
	//class properties
	int maxNumberOfLines;
	int minNumberOfLines;
	
	BOOL animateHeightChange;
    NSTimeInterval animationDuration;
	
	//uitextview properties
	NSObject <HPGrowingTextViewDelegate> *__unsafe_unretained delegate;
	NSTextAlignment textAlignment;
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
    
    UIEdgeInsets contentInset;
}

//real class properties
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property (nonatomic) int maxHeight;
@property (nonatomic) int minHeight;
@property BOOL animateHeightChange;
@property NSTimeInterval animationDuration;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UITextView *internalTextView;	


//uitextview properties
@property(unsafe_unretained) NSObject<HPGrowingTextViewDelegate> *delegate;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;    // default is NSTextAlignmentLeft
@property(nonatomic) NSRange selectedRange;            // only ranges of length 0 are supported
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0);
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (assign) UIEdgeInsets contentInset;
@property (nonatomic) BOOL isScrollable;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

//uitextview methods
//need others? use .internalTextView
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

// call to force a height change (e.g. after you change max/min lines)
- (void)refreshHeight;

@end
