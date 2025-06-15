#tag Class
Protected Class CheckboxElement
Implements Element
	#tag Method, Flags = &h0
		Sub Constructor(Caption as string)
		  
		  Self.Caption = Caption
		  
		  mRandomID = EncodeHex(crypto.GenerateRandomBytes(16))
		  
		  #Pragma BreakOnExceptions False
		  Try
		    mRandomID = session.Identifier + "_" + mRandomID
		  Catch ex As SessionNotAvailableException
		    
		  End Try
		  #Pragma BreakOnExceptions True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(delimiter as string = "") As String
		  Dim div As New DOM.HTMLElement("div")
		  div.AddClass("form-check")
		  If Inline Then
		    div.AddClass("form-check-inline")
		  End If
		  If ReverseAlignment Then
		    div.AddClass("form-check-reverse")
		  End If
		  
		  Dim Input As DOM.HTMLElement = div.AddChild("input")
		  Input.AddClass("form-check-input")
		  Input.SetAttribute("type", "checkbox")
		  Input.SetAttribute("value", "")
		  Input.SetAttribute("id", mRandomID)
		  Input.SetAttribute("aria-label", caption)
		  If Not Enabled Then
		    Input.SetAttribute("disabled", "")
		  End If
		  If value Then
		    Input.SetAttribute("checked", "")
		  End If
		  
		  If Switch Then
		    Input.SetAttribute("role", "switch")
		    Input.SetAttribute("switch", "")
		  End If
		  If Action.Trim<>"" Then
		    Input.SetAttribute("onclick", Action.Trim)
		  End If
		  
		  If ShowLabel Then
		    Dim label As DOM.HTMLElement = div.AddChild("label")
		    label.AddClass("form-check-label")
		    label.SetAttribute("for", mRandomID)
		    label.AddText(caption)
		  End If
		  
		  Return Element(div).ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Action As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Enabled As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Inline As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRandomID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ReverseAlignment As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ShowLabel As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Switch As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Value As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Caption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Switch"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Inline"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReverseAlignment"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowLabel"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Action"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
