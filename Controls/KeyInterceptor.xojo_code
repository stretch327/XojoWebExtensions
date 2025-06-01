#tag Class
Protected Class KeyInterceptor
Inherits WebSDKUIControl
	#tag Event
		Sub ContextualMenuSelected(hitItem As WebMenuItem)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DrawControlInLayoutEditor(g As Graphics)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function ExecuteEvent(name As String, parameters As JSONItem) As Boolean
		  Select Case name
		  Case "pressed"
		    Dim key As JSONItem = Parameters.Lookup("key", Nil)
		    
		    Dim keyname As String = key.Value("key")
		    Dim metakey As Boolean = key.Value("meta")
		    Dim shiftkey As Boolean = key.Value("shift")
		    Dim altkey As Boolean = key.Value("alt")
		    Dim controlkey As Boolean = key.Value("control")
		    
		    If EventCallback<>Nil Then
		      EventCallback.Invoke(Self, keyname, metakey, shiftkey, altkey, controlkey)
		    Else
		      RaiseEvent Pressed(keyname, metakey, shiftkey, altkey, controlkey)
		    End If
		    
		  End Select
		End Function
	#tag EndEvent

	#tag Event
		Function HandleRequest(request As WebRequest, response As WebResponse) As Boolean
		  break
		End Function
	#tag EndEvent

	#tag Event
		Sub Hidden()
		  mActivated = False
		  
		  RaiseEvent Hidden
		  Self.UpdateControl
		End Sub
	#tag EndEvent

	#tag Event
		Function JavaScriptClassName() As String
		  return JSClassName
		End Function
	#tag EndEvent

	#tag Event
		Sub Serialize(js As JSONItem)
		  Dim keyArray As New JSONItem("[]")
		  
		  For i As Integer = 0 To mKeys.LastRowIndex
		    Dim key As New JSONItem
		    
		    key.Value("key") = mKeys(i).Left.StringValue
		    key.Value("meta") = mKeys(i).Right.StringValue.Contains("M")
		    key.Value("shift") = mKeys(i).Right.StringValue.Contains("S")
		    key.Value("alt") = mKeys(i).Right.StringValue.Contains("A")
		    key.Value("control") = mKeys(i).Right.StringValue.Contains("C")
		    
		    keyArray.Add(key)
		  Next
		  js.Value("active") = mActivated
		  js.Value("keys") = keyArray
		End Sub
	#tag EndEvent

	#tag Event
		Function SessionCSSURLs(session As WebSession) As String()
		  
		End Function
	#tag EndEvent

	#tag Event
		Function SessionHead(session As WebSession) As String
		  //
		End Function
	#tag EndEvent

	#tag Event
		Function SessionJavascriptURLs(session As WebSession) As String()
		  // Create a webfile to contain the callback javascript code,
		  // but globally without session info so we're not creating this
		  // over and over
		  If SharedJSClassFile = Nil Then
		    Dim domain As String = JSClassName.NthField(".",1)
		    Dim className As String = JSClassName.NthField(".",2)
		    Dim code As String = kJSCode.ReplaceAll("websdkdomainname", domain).ReplaceAll("websdkcontrolname", className)
		    SharedJSClassFile = New WebFile
		    SharedJSClassFile.MIMEType = "text/javascript"
		    SharedJSClassFile.Session = Nil
		    SharedJSClassFile.Filename = "keyinterceptor.js"
		    SharedJSClassFile.Data = code
		  End If
		  
		  Return Array (SharedJSClassFile.URL)
		End Function
	#tag EndEvent

	#tag Event
		Sub Shown()
		  mActivated = True
		  RaiseEvent Shown
		  Self.UpdateControl
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Add(key as string, meta as boolean, shift as Boolean = False, option as boolean = False, control as Boolean = false)
		  
		  mKeys.Add EncodeKey(key, meta, shift, option, control)
		  self.UpdateControl
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BoolToString(value as Boolean, TrueValue as string, FalseValue as string = "") As String
		  If value Then
		    Return TrueValue
		  End If
		  
		  return FalseValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeKey(key as string, meta as boolean, shift as Boolean = False, option as boolean = False, control as Boolean = false) As Pair
		  Dim p As pair = key : BoolToString(meta,"M") + BoolToString(shift, "S") + BoolToString(option, "A") + BoolToString(control, "C")
		  return p
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub EventDelegate(obj as KeyInterceptor, key as string, Meta as boolean, Shift as Boolean, Alt as Boolean, Control as Boolean)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Function JSClassName() As String
		  return "sos.keyinterceptor"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key as string, meta as boolean, shift as Boolean = False, option as boolean = False, control as Boolean = false)
		  For i As Integer = 0 To mKeys.LastIndex
		    If mKeys(i).Left.StringValue = key Then
		      Dim modifiers As String = mKeys(i).Right.StringValue
		      
		      If (meta = modifiers.Contains("M")) And (shift = modifiers.Contains("S")) And (option = modifiers.Contains("A")) And (control = modifiers.Contains("C")) Then
		        mKeys.removeat(i)
		        i = i - 1
		      End If
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  mKeys.ResizeTo(-1)
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Hidden()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Pressed(key as string, Meta as boolean, Shift as Boolean, Alt as Boolean, Control as Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Shown()
	#tag EndHook


	#tag Property, Flags = &h0
		EventCallback As EventDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mActivated As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeys() As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared SharedJSClassFile As WebFile
	#tag EndProperty


	#tag Constant, Name = kJSCode, Type = String, Dynamic = False, Default = \"var websdkdomainname;\n(function (websdkdomainname) {\n\tclass websdkcontrolname extends XojoWeb.XojoVisualControl {\n\t\tconstructor(target\x2C events) {\n\t\t\tsuper(target\x2C events);\n\n\t\t\tthis.mKeys \x3D [];\n\t\t\tthis.mActive \x3D false;\n\t\t\tthis.eventHandlerSet \x3D false;\n\t\t\tthis.mReady \x3D false; // used to indicate that the control is not yet ready for use\n\t\t\tthis.setupEventHandler();\n\t\t}\n\n\t\tcallback(ev) {\n\t\t\tif (this.mActive && this.eventHandlerSet) {\n\t\t\t\tlet i \x3D 0;\n\t\t\t\tfor (i \x3D 0; i < this.mKeys.length; i++) {\n\t\t\t\t\tlet key \x3D this.mKeys[i];\n\t\t\t\t\tif (ev.key.toLowerCase() \x3D\x3D key.key.toLowerCase() && (ev.metaKey \x3D\x3D key.meta) && (ev.shiftKey \x3D\x3D key.shift) && (ev.altKey \x3D\x3D key.alt) && (ev.ctrlKey \x3D\x3D key.control)) {\n\t\t\t\t\t\tev.stopPropagation();\n\t\t\t\t\t\tev.preventDefault();\n\t\t\t\t\t\t// send the key info to the server\n\t\t\t\t\t\tlet datum \x3D { key: key };\n\t\t\t\t\t\tthis.triggerServerEvent(\"pressed\"\x2C datum\x2C true);\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\n\t\tsetupEventHandler() {\n\t\t\tthis.eventHandlerSet \x3D true;\n\t\t\tlet that \x3D this;\n\t\t\tdocument.addEventListener(\'keydown\'\x2C function (ev) {\n\t\t\t\tthat.callback(ev);\n\t\t\t});\n\t\t}\n\n\t\tupdateControl(data) {\n\t\t\tsuper.updateControl(data);\n\t\t\tlet js \x3D $.parseJSON(data);\n\t\t\tthis.mKeys \x3D js.keys;\n\t\t\tthis.mActive \x3D js.active;\n\t\t\tthis.mReady \x3D true;\n\t\t}\n\n\t}\n\twebsdkdomainname.websdkcontrolname \x3D websdkcontrolname;\n})(websdkdomainname || (websdkdomainname \x3D {}));\n", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="_mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Group="Appearance"
			InitialValue=""
			Type="Boolean"
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
			Name="PanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
