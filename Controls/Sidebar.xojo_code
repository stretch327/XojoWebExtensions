#tag Class
Protected Class Sidebar
Inherits WebSDKUIControl
	#tag Event
		Sub DrawControlInLayoutEditor(g As Graphics)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function ExecuteEvent(name As String, parameters As JSONItem) As Boolean
		  Select Case name
		  Case "titleclicked"
		    RaiseEvent TitleClicked
		    
		  Case "itemclicked"
		    Dim row As Integer = parameters.Lookup("index", -1)
		    If row > -1 Then
		      RaiseEvent RowClicked(row)
		    End If
		    
		  End Select
		End Function
	#tag EndEvent

	#tag Event
		Function HandleRequest(request As WebRequest, response As WebResponse) As Boolean
		  
		End Function
	#tag EndEvent

	#tag Event
		Function JavaScriptClassName() As String
		  return kJSClassName
		End Function
	#tag EndEvent

	#tag Event
		Sub Serialize(js As JSONItem)
		  js.Value("elements") = mElements
		  js.Value("title") = mTitle
		  js.Value("selectedIndex") = mSelectedIndex
		  js.Value("appearance") = CType(mAppearance, integer)
		End Sub
	#tag EndEvent

	#tag Event
		Function SessionCSSURLs(session As WebSession) As String()
		  
		End Function
	#tag EndEvent

	#tag Event
		Function SessionHead(session As WebSession) As String
		  return "<link rel=""stylesheet"" href=""https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"">"
		End Function
	#tag EndEvent

	#tag Event
		Function SessionJavascriptURLs(session As WebSession) As String()
		  Dim arr() As String
		  
		  If mjslib = Nil Then 
		    Dim classname() As String = kJSClassName.Split(".")
		    mjslib = New WebFile
		    mjslib.Session = Nil
		    mjslib.MIMEType = "application/javascript"
		    mjslib.Filename = classname(1) + ".js"
		    mjslib.Data = kJSCode.ReplaceAll("company_name", classname(0)).ReplaceAll("control_name", classname(1))
		  End If
		  
		  
		  arr.Add mjslib.URL
		  
		  Return arr
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Add(caption as string, icon as string = "")
		  Dim js As New JSONItem
		  js.Value("text") = caption
		  js.Value("icon") = icon
		  mElements.Add(js)
		  
		  Self.UpdateControl
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddAt(index as integer, caption as string, icon as string = "")
		  Dim js As New JSONItem
		  js.Value("text") = caption
		  js.Value("icon") = icon
		  mElements.AddAt(index, js)
		  
		  Self.UpdateControl
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddSeparator()
		  self.add("-")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddSeparatorAt(index as integer)
		  self.AddAt(index, "-")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CaptionAt(index as integer) As String
		  Dim item As JSONItem = mElements.ChildAt(index)
		  return item.Value("text")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From WebSDKUIControl
		  // Constructor() -- From WebUIControl
		  // Constructor() -- From WebControl
		  Super.Constructor
		  
		  
		  mTitle = New JSONItem
		  mElements = new JSONItem("[]")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IconAt(index as integer) As String
		  Dim item As JSONItem = mElements.ChildAt(index)
		  return item.Value("icon")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  mElements = New JSONItem("[]")
		  mSelectedIndex = -1
		  Self.UpdateControl
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(index as integer)
		  mElements.RemoveAt(index)
		  Self.UpdateControl
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValueAt(index as integer, caption as string, icon as string = "")
		  Dim js As New JSONItem
		  js.Value("text") = caption
		  js.Value("icon") = icon
		  mElements.ValueAt(index) = js
		  
		  Self.UpdateControl
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event RowClicked(index as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TitleClicked()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mAppearance
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAppearance = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		Appearance As Sidebar.Appearances
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mElements = Nil Then
			    Return 0
			  End If
			  
			  return mElements.Count
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAppearance As Sidebar.Appearances
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mElements As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mjslib As WebFile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitle As JSONItem
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSelectedIndex
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSelectedIndex = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		SelectedRowIndex As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTitle.Lookup("text", "")
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTitle.Value("text") = value
			  Self.UpdateControl
			End Set
		#tag EndSetter
		Title As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTitle.Lookup("icon", "")
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTitle.Value("icon") = value
			  Self.UpdateControl
			End Set
		#tag EndSetter
		TitleIcon As String
	#tag EndComputedProperty


	#tag Constant, Name = kJSClassName, Type = String, Dynamic = False, Default = \"sos.sidebar", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJSCode, Type = String, Dynamic = False, Default = \"var company_name;\n(function(company_name) {\n  class control_name extends XojoWeb.XojoVisualControl {\n    constructor(id\x2C events) {\n      super(id\x2C events);\n      this.mElements \x3D [];\n      this.mTitle \x3D null;\n      this.mSelectedIndex \x3D -1;\n    }\n\n    render() {\n      super.render();\n      let el \x3D this.DOMElement();\n      if(!el) return;\n      this.setAttributes();\n\n      // set the background and text color based on the appearance\n      let appearance \x3D this.isDarkMode();\n      let textColor \x3D \"text-black\";\n      let selectedTextColor \x3D \"text-white\";\n      let backgroundColor \x3D \"bg-body-tertiary\";\n      switch (appearance) {\n        case \"dark\":\n          textColor \x3D \"text-white\";\n          backgroundColor \x3D \"bg-dark\";\n          break;\n        case \"light\":\n          textColor \x3D \"text-black\";\n          backgroundColor \x3D \"bg-body-tertiary\";\n          break;\n      }\n\n      // create the top level div if it doesn\'t exist\n      let topdiv \x3D el.querySelector(\"div\");\n      if(!topdiv) {\n        topdiv \x3D document.createElement(\"div\");\n        el.appendChild(topdiv);\n        topdiv.classList \x3D \"d-flex flex-column flex-shrink-0 p-3\";\n        topdiv.classList.add(backgroundColor);\n        topdiv.style.width \x3D \"280px\";\n        topdiv.style.height \x3D \"100%\";\n      }\n\n      // remove all children\n      topdiv.innerHTML \x3D \'\';\n      \n      let that \x3D this;\n      // re-add children\n      // add the title if it exists\n      if(this.mTitle) {\n\t      let shouldAdd \x3D false;\n        let link \x3D document.createElement(\"a\");\n        link.classList \x3D \"d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none\";\n        if (appearance \x3D\x3D\x3D \"dark\") {\n          link.classList.add(textColor);\n        } else {\n          link.classList.add(\"link-body-emphasis\");\n        }\n        link.addEventListener(\"click\"\x2C (e) \x3D> {\n            e.preventDefault();\n            e.stopPropagation();\n            that.sendTitleClick();\n        });\n        \n        if(this.mTitle.icon !\x3D null && this.mTitle.icon !\x3D \"\") {\n          let icon \x3D document.createElement(\"i\");\n          icon.classList \x3D \"bi bi-\" + this.mTitle.icon;\n          icon.style.paddingRight \x3D \"1em\";\n          link.appendChild(icon);\n\t        shouldAdd \x3D true;\n        }\n        \n\t      if(this.mTitle.text !\x3D null && this.mTitle.text !\x3D \"\") {\n        \tlet title \x3D document.createElement(\"span\");\n        \ttitle.classList \x3D \"fs-4\";\n        \ttitle.textContent \x3D this.mTitle.text;\n        \tlink.appendChild(title);\n\t    \t  shouldAdd \x3D true;\n  \t    }\n\n        if (shouldAdd) {\n          topdiv.appendChild(link);\n        \t// add a horizontal rule\n        \ttopdiv.appendChild(document.createElement(\"hr\"));\n\t      }\n      }\n\n      let itemgroup \x3D document.createElement(\"ul\");\n      itemgroup.classList \x3D \"nav nav-pills flex-column mb-auto\";\n      topdiv.appendChild(itemgroup);\n      let i;\n      // add each element\n      for(i\x3D0;i<this.mElements.length;i++) {\n        let item \x3D this.mElements[i];\n        if(item.text \x3D\x3D \"-\") {\n          itemgroup.appendChild(document.createElement(\"hr\"));\n          continue;\n        } \n\n        let isSelected \x3D (this.mSelectedIndex \x3D\x3D\x3D i);\n        let li \x3D document.createElement(\"li\");\n        itemgroup.appendChild(li);\n        if (isSelected) {\n          li.classList \x3D \"nav-item\";\n        }\n\n        let link \x3D document.createElement(\"a\");\n        li.appendChild(link);\n        link.classList \x3D \"nav-link\";\n        if (isSelected) {\n          link.classList.add(\"active\");\n          link.classList.add(selectedTextColor);\n        } else {\n          link.classList.add(textColor);\n        }\n\n        link.addEventListener(\"click\"\x2C (e) \x3D> {\n            e.preventDefault();\n            e.stopPropagation();\n            that.sendElementClick(e);\n        });\n\n        link.href \x3D \"javascript:XojoWeb.getNamedControl(\'\" + this.controlID() + \"\').sendElementClick(\" + i + \")\";\n        link.href \x3D \"#\";\n        link.setAttribute(\"idx\"\x2C i);\n\n        if(item.icon !\x3D null && item.icon !\x3D \"\") {\n            let icon \x3D document.createElement(\"i\");\n            icon.classList \x3D \"bi bi-\" + item.icon;\n            icon.setAttribute(\"idx\"\x2C i);\n            link.appendChild(icon);\n        }\n        link.appendChild(document.createTextNode(\" \" + item.text));\n      }\n    }\n\n    // get the light/dark\n    isDarkMode() {\n      // ask the browser what it\'s light/dark mode isand mix that with the control\'s appearance setting\n      let isDarkMode \x3D window.matchMedia && window.matchMedia(\'(prefers-color-scheme: dark)\').matches;\n      let appearance \x3D \"light\";\n\n      switch (this.mAppearance) {\n        case 0: // Auto\n          appearance \x3D isDarkMode \? \"dark\" : \"light\";\n          break;\n        case 1: // Light\n          appearance \x3D \"light\";\n          break;\n        case 2: // Dark\n          appearance \x3D \"dark\";\n          break;\n        default:\n          appearance \x3D isDarkMode \? \"dark\" : \"light\";\n          break;\n      }\n   \n      return appearance;\n  }\n    // send event when the title is clicked\n    sendTitleClick() {\n      this.triggerServerEvent(\"titleclicked\"\x2C {}\x2C true);\n    }\n\n    // send event when an element is clicked\n    sendElementClick(ev) {\n        let el \x3D ev.target;\n        let index \x3D parseInt(el.getAttribute(\"idx\")\x2C 10);\n        let item \x3D this.mElements[index];\n        if(item) {\n            var datum \x3D { index : index };\n            this.triggerServerEvent(\"itemclicked\"\x2C datum\x2C true);\n            this.mSelectedIndex \x3D index;\n            this.refresh();\n        }\n    }\n\n    updateControl(data) {\n      super.updateControl(data);\n      let js \x3D JSON.parse(data);\n      this.mElements \x3D js.elements;\n      this.mTitle \x3D js.title;\n      this.mSelectedIndex \x3D js.selectedIndex;\n      this.mAppearance \x3D js.appearance;\n      this.refresh();\n    }\n  }\n  company_name.control_name \x3D control_name;\n})(company_name || (company_name \x3D {}));", Scope = Private
	#tag EndConstant


	#tag Enum, Name = Appearances, Type = Integer, Flags = &h0
		Auto
		  Light
		Dark
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="400"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="280"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockHorizontal"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockVertical"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelectedRowIndex"
			Visible=true
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TitleIcon"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Appearance"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Sidebar.Appearances"
			EditorType="Enum"
			#tag EnumValues
				"0 - Auto"
				"1 - Light"
				"2 - Dark"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Visual Controls"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Visual Controls"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Indicator"
			Visible=false
			Group="Visual Controls"
			InitialValue=""
			Type="WebUIControl.Indicators"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Primary"
				"2 - Secondary"
				"3 - Success"
				"4 - Danger"
				"5 - Warning"
				"6 - Info"
				"7 - Light"
				"8 - Dark"
				"9 - Link"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="PanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mPanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
