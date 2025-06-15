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

### SimpleWebSDK

This control is a simplified sdk for creating controls for use in your projects. Perhaps you're prototyping a control and don't want to spend the time to create all of the different parts or it's simple enough that rendering the control on the server is good enough for your use. Regardless, this control is a cross between the WebHTMLViewer and the Callback example project, combined with a set of classes for making HTML programmatically. Inside the Examples folder, you'll find a sample Bootstrap table control much like the one that was available in Web 1.0. No datasource, no sorting. Just rows & columns. Features were taken from https://getbootstrap.com/docs/5.3/content/tables/

NOTES:

1. While the inline buttons in the table work, the checkbox functionality has not been fully fleshed out yet as it's merely an example project.

2. In the HTML Document Object Model classes, if you come across a property named **Action**, the value that should be placed in that property is the result of calling the **MakeCallback** method of your control that is a subclass of **SimpleWebSDKUIControl**. This method takes two properties:

   1. eventName as String - Typically the name of the thing that's sending the data
   2. data as String - Data sent for this particular item, either a string value or a JSON string.

   when the user activates the selected item, the **BrowserCallback** event will be raised containing the eventName and the data presented as specified when you called **MakeCallback**.