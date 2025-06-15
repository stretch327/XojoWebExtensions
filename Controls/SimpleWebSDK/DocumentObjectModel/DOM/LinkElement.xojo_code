#tag Class
Protected Class LinkElement
Implements Element
	#tag Method, Flags = &h0
		Sub Constructor(caption as string)
		  // Calling the overridden superclass constructor.
		  
		  self.Caption = caption
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(delimiter as string = "") As String
		  
		  Dim link As New DOM.HTMLElement("a")
		  link.SetAttribute("href", action)
		  If Not Underlined Then
		    link.AddClass("text-decoration-none")
		  End If
		  If OpenInNewPage Then
		    link.SetAttribute("target", "_blank")
		  End If
		  
		  link.AddText(caption)
		  
		  Return link.ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Action As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		OpenInNewPage As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Underlined As Boolean = True
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
			Name="Action"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Caption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underlined"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
