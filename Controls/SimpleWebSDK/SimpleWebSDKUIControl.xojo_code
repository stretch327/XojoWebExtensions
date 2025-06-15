#tag Class
Protected Class SimpleWebSDKUIControl
Inherits WebSDKUIControl
	#tag Event
		Sub DrawControlInLayoutEditor(g As Graphics)
		  Dim kControlName As String = ConstantValue("kControlName")
		  
		  g.ClearRectangle 0, 0, g.Width, g.Height
		  
		  g.DrawingColor = TextColor
		  g.DrawRectangle 0, 0, g.Width, g.Height
		  
		  g.FontName = "Arial"
		  g.FontSize = 48
		  g.Bold = True
		  Dim w As Double = g.TextWidth(kControlName)
		  Dim textSpace As Double = g.Width * 0.8
		  
		  While w > textSpace And g.FontSize >= 8
		    g.FontSize = g.FontSize - 4
		    w = g.TextWidth(kControlName)
		  Wend
		  
		  Dim x As Integer = (g.Width - g.TextWidth(kControlName))/2
		  Dim y As Integer = (g.Height + g.FontAscent) / 2
		  
		  g.DrawText kControlName, x, y
		End Sub
	#tag EndEvent

	#tag Event
		Function ExecuteEvent(name As String, parameters As JSONItem) As Boolean
		  // convert the data from base64 back into a string
		  Dim data As String = DecodeBase64(parameters.Value("data"))
		  
		  RaiseEvent BrowserCallback(name, data)
		  
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Function HandleRequest(request As WebRequest, response As WebResponse) As Boolean
		  // Hidden from end users
		End Function
	#tag EndEvent

	#tag Event
		Function JavaScriptClassName() As String
		  Return kJSClassName
		End Function
	#tag EndEvent

	#tag Event
		Sub Serialize(js As JSONItem)
		  // Hidden from end users
		  js.Value("html") = EncodeBase64(Render, 0)
		End Sub
	#tag EndEvent

	#tag Event
		Function SessionCSSURLs(session As WebSession) As String()
		  
		End Function
	#tag EndEvent

	#tag Event
		Function SessionJavascriptURLs(session As WebSession) As String()
		  // Create a webfile to contain the callback javascript code,
		  // but globally without session info so we're not creating this
		  // over and over
		  If SharedJSClassFile = Nil Then
		    Dim companyName As String = kJSClassName.NthField(".", 1)
		    Dim controlName As String = kJSClassName.NthField(".", 2)
		    
		    Dim code As String = kJSCode.ReplaceAll("company_name", companyName).ReplaceAll("control_name", controlName)
		    
		    SharedJSClassFile = New WebFile
		    SharedJSClassFile.MIMEType = "text/javascript"
		    SharedJSClassFile.Session = Nil
		    SharedJSClassFile.Filename = controlName + ".js"
		    SharedJSClassFile.Data = code
		  End If
		  
		  Return Array (SharedJSClassFile.URL)
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Function MakeCallback(eventName as string, data as string) As String
		  // encode the passed data as base64 so we don't get transmission errors
		  
		  Return "javascript:XojoWeb.getNamedControl('" + Self.controlID + "').callback('" + eventName + "','" + EncodeBase64(data, 0) + "');" 
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event BrowserCallback(eventName as string, data as String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Render() As String
	#tag EndHook


	#tag Property, Flags = &h21
		#tag Note
			This property is so we don't have separate WebFile objects for each session, since the contents will always be the same.
		#tag EndNote
		Private Shared SharedJSClassFile As WebFile
	#tag EndProperty


	#tag Constant, Name = kControlName, Type = String, Dynamic = False, Default = \"SimpleWebSDK", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kJSClassName, Type = String, Dynamic = False, Default = \"sos.simplewebsdkcontrol", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJSCode, Type = String, Dynamic = False, Default = \"var company_name;\n(function (company_name) {\n    class control_name extends XojoWeb.XojoVisualControl {\n        constructor(target\x2C events) {\n            super(target\x2C events);\n\n            this.mHTML \x3D \"\";\n        }\n        callback(eventName\x2C datum) {\n\t    datum \x3D { data : datum };\n            this.triggerServerEvent(eventName\x2C datum\x2C true);\n        }\n\n        render() {\n            super.render();\n            let el \x3D this.DOMElement();\n            if (!el) return;\n            this.setAttributes();\n\n            el.innerHTML \x3D this.mHTML;\n        }\n\n        updateControl(data) {\n            super.updateControl(data);\n            let js \x3D JSON.parse(data);\n            this.mHTML \x3D XojoWeb.DecodeBase64(js.html);\n        }\n\n    }\n    company_name.control_name \x3D control_name;\n})(company_name || (company_name \x3D {}));", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
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
			InitialValue="34"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
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
			InitialValue="False"
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
			Name="ControlID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="_mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Visible=true
			Group="Visual Controls"
			InitialValue="0"
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
	#tag EndViewBehavior
End Class
#tag EndClass
