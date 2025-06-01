# XojoWebExtensions

A Collection of controls and utilities for use with Xojo's Web Framework 2.0

### KeyInterceptor 

A control for intercepting specific keystrokes on the end user's browser, raising an event on the control. The control is sensitive to Shown and Hidden events so it will automatically enable and disable as necessary.

NOTE: Some browsers (I'm looking at you Safari) choose not to allow you to capture certain keystrokes. 

Usage:

1. Drop the control on the page where you want to catch keystrokes. It does not need to be on the visible part of the page.
2. Implement the Pressed event or set the EventCallback property
3. Call **Add** to add keys that you want to capture. Meta is Command on MacOS and Control on Windows/Linux.
4. Call **Remove** with the same parameters to remove the capture.
5. Call **RemoveAll** to remote all key captures.