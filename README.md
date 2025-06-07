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

### Sidebar

A sidebar control in the style presented in the bootstrap docs. This control is dark-mode aware and can be set to Light, Dark or Auto.

1. Drop the control on the page
2. In the Opening event, add the items you want using the Add method. Icon names are from [icons.getbootstrap.com]().
3. When the user clicks an item in the list, the RowClicked event will fire with the index of the item that was clicked. REMEMBER: Separators also have indexes, so you may want to use the CaptionAt method to check the item that was actually selected.