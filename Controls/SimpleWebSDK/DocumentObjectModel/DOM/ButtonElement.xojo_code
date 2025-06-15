#tag Class
Protected Class ButtonElement
Implements Element
	#tag Method, Flags = &h0
		Sub Constructor(caption as string)
		  
		  self.Caption = caption
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(delimiter as string = "") As String
		  
		  Dim button As New DOM.HTMLElement("a") // we use a link so we can have an action
		  button.SetAttribute("type", "button")
		  button.AddClass("btn")
		  Dim prefix As String = "btn"
		  If Outline Then
		    prefix = "btn-outline"
		  End If
		  
		  button.AddClass(DOM.IndicatorToString(Self.Indicator, prefix))
		  
		  If Not WrapText Then
		    button.AddClass("text-nowrap")
		  End If
		  
		  Select Case Self.Size
		  Case Sizes.Small
		    button.AddClass("btn-sm")
		  Case sizes.Large
		    button.AddClass("btn-lg")
		  End Select
		  
		  If Not Enabled Then
		    button.AddClass("disabled")
		    button.SetAttribute("aria-disabled", "true")
		    button.SetAttribute("tabindex", "-1")
		  Else
		    button.SetAttribute("href", action.Trim)
		  End If
		  
		  button.AddText(caption)
		  
		  Return button.ToString
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
		Indicator As WebUIControl.Indicators
	#tag EndProperty

	#tag Property, Flags = &h0
		Outline As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Size As DOM.ButtonElement.Sizes
	#tag EndProperty

	#tag Property, Flags = &h0
		WrapText As Boolean = True
	#tag EndProperty


	#tag Enum, Name = Sizes, Type = Integer, Flags = &h0
		Small = -1
		  Medium = 0
		Large = 1
	#tag EndEnum


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
			Name="Action"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
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
			Name="Indicator"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="WebUIControl.Indicators"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Outline"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Size"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ButtonElement.Sizes"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WrapText"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
