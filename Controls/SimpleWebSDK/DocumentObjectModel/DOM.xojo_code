#tag Module
Protected Module DOM
	#tag Method, Flags = &h1
		Protected Function IndicatorToString(indicator as WebUIControl.Indicators, prefix as string) As String
		  Select Case indicator
		  Case WebUIControl.Indicators.Danger
		    Return prefix + "-danger"
		  Case WebUIControl.Indicators.Dark
		    Return prefix + "-dark"
		  Case WebUIControl.Indicators.Info
		    Return prefix + "-info"
		  Case WebUIControl.Indicators.Light
		    Return prefix + "-light"
		  Case WebUIControl.Indicators.Primary
		    Return prefix + "-primary"
		  Case WebUIControl.Indicators.Secondary
		    Return prefix + "-secondary"
		  Case WebUIControl.Indicators.Success
		    Return prefix + "-success"
		  Case WebUIControl.Indicators.Warning
		    Return prefix + "-warning"
		  End Select
		End Function
	#tag EndMethod


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
	#tag EndViewBehavior
End Module
#tag EndModule
