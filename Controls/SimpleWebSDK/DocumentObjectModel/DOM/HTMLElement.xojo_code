#tag Class
Protected Class HTMLElement
Implements Element
	#tag Method, Flags = &h0
		Sub AddChild(child as Element)
		  mChildren.Add(child)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddChild(tag as string) As DOM.HTMLElement
		  Dim ch As New DOM.HTMLElement(tag)
		  Self.AddChild(ch)
		  return ch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddChildAt(index as integer, child as Element)
		  mChildren.AddAt(index, child)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddClass(name as string)
		  If name.Trim<>"" Then
		    mClasses.Add(name)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddClassAt(index as integer, name as string)
		  mClasses.AddAt(index, name)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddText(text as string)
		  mChildren.add new TextElement(text)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChildAt(index as integer) As Element
		  return mChildren(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ClassAt(index as integer) As String
		  return mClasses(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ClassCount() As Integer
		  return mClasses.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(tag as string)
		  
		  Self.Tag = tag
		  
		  mAttributes = New Dictionary
		  mStyle = New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  Return mChildren.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAttribute(name as string) As String
		  // if the caller asks for "class" go get it from our mClasses array
		  If name = "class" Then
		    Dim rv As String = Join(mClasses, " ")
		    Return rv
		  End If
		  
		  If name = "style" Then
		    Dim keys() As Variant = mStyle.keys
		    Dim parts() As String
		    For i As Integer = 0 To keys.LastIndex
		      Dim key As String = keys(i).StringValue
		      Dim value As String = mStyle.Value(keys(i))
		      parts.Add key + ": " + value
		    Next
		    return join(parts, ";")
		  End If
		  
		  Return mAttributes.Lookup(name, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasAttribute(name as string) As Boolean
		  return mAttributes.HasKey(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasClass(name as string) As Boolean
		  Return mClasses.IndexOf(name) > -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAttribute(name as string)
		  If mAttributes.HasKey(name) Then
		    mAttributes.Remove(name)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveChild(child as Element)
		  For i As Integer = 0 To mChildren.LastIndex
		    If mChildren(i) = child Then
		      mChildren.RemoveAt(i)
		      i = i - 1
		    End If
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveChildAt(index as Integer)
		  mChildren.RemoveAt(index)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveClass(name as string)
		  Dim p As Integer = mClasses.IndexOf(name)
		  While p > -1
		    mClasses.RemoveAt(p)
		    p = mClasses.IndexOf(name)
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetAttribute(name as string, value as string)
		  // convert class into our classes structure, replacing what was there before
		  If name = "class" Then
		    mClasses.ResizeTo(-1)
		    Dim values() As String = Split(value, " ")
		    For i As Integer = 0 To values.LastIndex
		      If values(i).Trim<>"" Then
		        mClasses.Add values(i).Trim
		      End If
		    Next
		    
		    Return
		  End If
		  
		  // if the user sent style info, replace what's in the style dictionary
		  If name = "style" Then
		    mStyle = New Dictionary
		    Dim styleItems() As String = Split(value, ";")
		    For i As Integer = 0 To styleItems.LastIndex
		      If styleItems(i) = "" Then
		        Continue
		      End If
		      
		      Dim parts() As String = styleItems(i).Split(":")
		      If parts.Count = 2 Then
		        mStyle.Value(parts(0).Trim) = parts(1).Trim
		      End If
		    Next
		    
		    Return
		  End If
		  
		  mAttributes.Value(name) = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Style(name as string) As String
		  Return mStyle.Lookup(name, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Style(name as string, assigns value as Variant)
		  mStyle.Value(name) = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(delimiter as string = "") As String
		  // Browsers like windows line endings best so we'll make sure the user gets those
		  // if they specify any line ending
		  delimiter = delimiter.ReplaceLineEndings(EndOfLine.Windows)
		  
		  Dim parts() As String
		  
		  // make the initial tag
		  parts.Add "<" + tag
		  
		  // set its classes
		  If mClasses.Count > 0 Then
		    parts.Add "class=""" + Join(mClasses, " ") + """"
		  End If
		  
		  If mStyle.KeyCount > 0 Then
		    parts.Add "style=""" + GetAttribute("style") + ";"""
		  End If
		  
		  // apply any other attributes
		  Dim attributeKeys() As Variant = mAttributes.keys()
		  For i As Integer = 0 To attributeKeys.LastIndex
		    Dim key As String = attributeKeys(i)
		    Dim value As String = mAttributes.Value(key)
		    If value = "" Then
		      parts.Add key
		    Else
		      parts.Add key + "=""" + value + """"
		    End If
		  Next
		  
		  // add the end of the tag
		  parts.Add ">"
		  
		  // Generate the HTML that we're going to return
		  Dim html() As String
		  
		  // the tag we just created
		  html.Add Join(parts, " ")
		  
		  // Recursively add all of our children
		  For i As Integer = 0 To mChildren.LastIndex
		    html.Add mChildren(i).ToString
		  Next
		  
		  // only add end tags for things that need it
		  Dim exemptEndTags() As String = Array("img")
		  If exemptEndTags.IndexOf(tag) = -1 Then
		    html.Add "</" + tag + ">"
		  End If
		  
		  Return Join(html, delimiter)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAttributes As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mChildren() As Element
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mClasses() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStyle As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Tag As String
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
			Name="Tag"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
