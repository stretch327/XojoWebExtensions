#tag Class
Protected Class SimpleTable
Inherits SimpleWebSDKUIControl
	#tag Event
		Sub BrowserCallback(eventName as string, data as String)
		  
		  Select Case eventName
		  Case "action"
		    Try
		      Dim parameters As New JSONItem(data)
		      RaiseEvent Action(parameters.Value("name").stringValue, parameters.Value("row").IntegerValue)
		    Catch ex As JSONException
		      
		    End Try
		    
		  Case "nameClick"
		    SelectedRowIndex = Val(data)
		    RaiseEvent SelectionChanged
		    
		  Case "checkme"
		    CheckPressed(eventName, Val(data))
		    
		  End Select
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  RaiseEvent Opening
		  
		  // this is so users don't have to remember to call update if they're just using the Opening event
		  Self.UpdateControl
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function Render() As String
		  
		  Dim table As New DOM.HTMLElement("table")
		  table.AddClass("table")
		  If Self.StripedRows Then
		    table.AddClass("table-striped")
		  End If
		  If Self.StripedColumns Then
		    table.AddClass("table-striped-columns")
		  End If
		  table.AddClass(DOM.IndicatorToString(Self.Indicator, "table"))
		  If Self.HoverableRows Then
		    table.AddClass("table-hover")
		  End If
		  
		  // Header
		  Dim thead As DOM.HTMLElement = table.AddChild("thead")
		  Dim tr As DOM.HTMLElement = thead.AddChild("tr")
		  
		  For i As Integer = 0 To ColumnCount-1
		    Dim th As DOM.HTMLElement = tr.AddChild("th")
		    th.SetAttribute("scope", "col")
		    th.AddText Self.HeaderAt(i)
		  Next
		  
		  If actions.Count > 0 Then
		    Dim th As DOM.HTMLElement = tr.AddChild("th")
		    th.SetAttribute("scope", "col")
		    th.AddText "Actions"
		  End If
		  
		  // body
		  Dim tbody As DOM.HTMLElement = table.AddChild("tbody")
		  tbody.AddClass "align-middle"
		  
		  For r As Integer = 0 To mRowData.LastIndex
		    tr = tbody.AddChild("tr")
		    Dim row As SimpleTableRow = mRowData(r)
		    If r = SelectedRowIndex Then
		      tr.AddClass("table-active")
		    End If
		    Dim indicatorClass As String = DOM.IndicatorToString(row.Indicator, "table")
		    If indicatorClass <> "" Then
		      tr.AddClass(indicatorClass)
		    End If
		    
		    For c As Integer = 0 To ColumnCount-1
		      Dim td As DOM.HTMLElement = tr.AddChild("td")
		      If c = 0 Then
		        // for column 0, make the item a link
		        Dim link As New DOM.LinkElement(row.ValueAt(c))
		        link.Underlined = False
		        link.Action = Me.MakeCallback("nameClick", r.ToString)
		        td.AddChild(link)
		      Else
		        td.AddText(row.ValueAt(c))
		      End If
		      td.AddClass(DOM.IndicatorToString(row.IndicatorAt(c), "table"))
		    Next
		    
		    // add the action buttons if there are any with callbacks so we'll know which
		    // was clicked on which row
		    If actions.Count > 0 Then
		      Dim actionColumn As DOM.HTMLElement = tr.AddChild("td")
		      For Each button As DOM.ButtonElement In actions
		        // Clone the button (otherwise they all get the same exact action data)
		        Dim btn As New DOM.ButtonElement(button.Caption)
		        btn.Enabled = button.Enabled
		        btn.Indicator = button.Indicator
		        btn.Outline = button.Outline
		        btn.Size = button.Size
		        btn.WrapText = button.WrapText
		        
		        Dim actiondata As New JSONItem
		        actiondata.Value("name") = button.Caption
		        actiondata.Value("row") = r
		        btn.Action = Self.MakeCallback("action", actiondata.ToString) // EventName is transmitted to the BrowserCallback event
		        
		        actionColumn.AddChild(btn)
		        
		        actionColumn.AddText("&nbsp;")
		      Next
		      
		      Dim checkbox As New DOM.CheckboxElement("Check Me!")
		      checkbox.Action = Self.MakeCallback("checkme", r.ToString)
		      actionColumn.AddChild(checkbox)
		    End If
		  Next
		  
		  // render the table as html
		  Return table.ToString(EndOfLine.Windows)
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddRow(paramarray txt as string)
		  Dim row As New SimpleTableRow
		  
		  For i As Integer = 0 To txt.lastindex
		    row.ValueAt(i) = txt(i)
		  Next
		  
		  mRowData.Add(row)
		  
		  mLastAddedRowIndex = mRowData.LastIndex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRowAt(rowIndex as integer, paramarray txt as string)
		  Dim row As New SimpleTableRow
		  
		  For i As Integer = 0 To txt.lastindex
		    row.ValueAt(i) = txt(i)
		  Next
		  
		  mRowData.AddAt(rowIndex, row)
		  
		  mLastAddedRowIndex = mRowData.LastIndex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellTagAt(rowIndex as integer, columnIndex as integer) As Variant
		  Dim row As SimpleTableRow = mRowData(rowIndex)
		  return row.TagAt(columnIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellTagAt(rowIndex as integer, columnIndex as integer, assigns value as variant)
		  Dim row As SimpleTableRow = mRowData(rowIndex)
		  row.TagAt(columnIndex) = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CellTextAt(rowIndex as integer, columnIndex as integer, assigns value as string)
		  Dim row As SimpleTableRow = mRowData(rowIndex)
		  row.ValueAt(columnIndex) = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HeaderAt(columnIndex as integer) As String
		  While mHeaders.LastIndex < columnIndex
		    mHeaders.Add ""
		  Wend
		  
		  return mHeaders(columnIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HeaderAt(columnIndex as integer, assigns value as string)
		  While mHeaders.LastIndex < columnIndex
		    mHeaders.Add ""
		  Wend
		  
		  mHeaders(columnIndex) = value
		  
		  If columnIndex + 1 > ColumnCount Then
		    ColumnCount = columnIndex + 1
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRowAt(rowIndex as integer)
		  mRowData.RemoveAt(rowIndex)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowAt(rowIndex as integer) As SimpleTableRow
		  return mRowData(rowIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RowTagAt(rowIndex as integer) As Variant
		  Dim row As SimpleTableRow = mRowData(rowIndex)
		  return row.Tag
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RowTagAt(rowIndex as integer, assigns tag as Variant)
		  Dim row As SimpleTableRow = mRowData(rowIndex)
		  row.Tag = tag
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Action(caption as string, rowIndex as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CheckPressed(name as string, value as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Opening()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SelectionChanged()
	#tag EndHook


	#tag Property, Flags = &h0
		Actions() As DOM.ButtonElement
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mColumnCount
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mColumnCount = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		ColumnCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mHoverableRows
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHoverableRows = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		HoverableRows As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mIndicator
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mIndicator = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		Indicator As WebUIControl.Indicators
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLastAddedRowIndex
			End Get
		#tag EndGetter
		LastAddedRowIndex As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mRowData.LastIndex
			End Get
		#tag EndGetter
		LastRowIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mColumnCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaders() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHoverableRows As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIndicator As WebUIControl.Indicators
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastAddedRowIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRowData() As SimpleTableRow
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedRowIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStripedColumns As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStripedRows As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTags() As Variant
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mSelectedRowIndex
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSelectedRowIndex = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		SelectedRowIndex As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mStripedColumns
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mStripedColumns = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		StripedColumns As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mStripedRows
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mStripedRows = value
			  self.UpdateControl
			End Set
		#tag EndSetter
		StripedRows As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = kControlName, Type = String, Dynamic = False, Default = \"Bootstrap Table", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
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
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="400"
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
			Name="Enabled"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastAddedRowIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastRowIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
		#tag ViewProperty
			Name="SelectedRowIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StripedRows"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StripedColumns"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HoverableRows"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
