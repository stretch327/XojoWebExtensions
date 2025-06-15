#tag Class
Protected Class SimpleTableRow
	#tag Method, Flags = &h0
		Function IndicatorAt(columnIndex as integer) As WebUIControl.Indicators
		  return mCells(columnIndex).Indicator
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IndicatorAt(columnIndex as integer, assigns value as WebUIControl.Indicators)
		  mCells(columnIndex).Indicator = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TagAt(columnIndex as integer) As variant
		  While mCells.LastIndex < columnIndex
		    mCells.Add New SimpleTableCell
		  Wend
		  
		  Return mCells(columnIndex).Tag
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TagAt(index as integer, assigns value as variant)
		  While mCells.LastIndex < index
		    mCells.Add New SimpleTableCell
		  Wend
		  mCells(value).Tag = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAt(columnIndex as integer) As String
		  While mCells.LastIndex < columnIndex
		    mCells.Add  New SimpleTableCell
		  Wend
		  
		  return mCells(columnIndex).Text
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValueAt(index as integer, assigns value as string)
		  While mCells.LastIndex < index
		    mCells.Add  New SimpleTableCell
		  Wend
		  
		  mCells(index).Text = value
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Indicator As WebUIControl.Indicators
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCells() As SimpleTableCell
	#tag EndProperty

	#tag Property, Flags = &h0
		Tag As Variant
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
			Name="Indicator"
			Visible=false
			Group="Behavior"
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
	#tag EndViewBehavior
End Class
#tag EndClass
