* TreeView101.prg
* creates a treeview
* By CarlKarsten

RELEASE goOtForm
PUBLIC goOtForm

* Create a form with a treeview on it
goOtForm = CREATEOBJECT( "cForm" )

* do some things to the treeview
* Add the first node (aka the Root)
goOtForm.tree1.Nodes.Add( , , "A1", "Hello" )

* Add a child, under the Root (4)
loNode = goOtForm.tree1.Nodes.item["A1"]
goOtForm.tree1.Nodes.Add( loNode, 4, "A2", "World" )

* Make the A2 node visible
goOtForm.tree1.Nodes.item["A2"].EnsureVisible()

* Add 20 more nodes under A2
loNode = goOtForm.tree1.Nodes.item["A2"]
For lnI = 1 to 20
	lcKey = "B" + Transform(lnI)
	goOtForm.tree1.Nodes.Add( loNode, 4, lcKey, "Moon " + Transform(lnI) )
endfor

* Expand the A2 subtree (scrools the A1 off the top)
goOtForm.tree1.Nodes.item["A2"].Expanded = .t.

* Make the A1 node visible again
loNode = goOtForm.tree1.Nodes.item["A1"].EnsureVisible()

Return


DEFINE CLASS cForm as Form

	PROCEDURE init( toBO )

		WITH this
			
			.show()
			
			.AddObject('cmdCancel', 'cCancel' )
			.cmdCancel.visible = .t.
			
			.AddObject('tree1', 'olecontrol', 'COMCtl.treectrl')
			WITH .tree1
				.visible = .t.
				.height = thisform.height - 35
				.width = thisform.width - 20
			ENDWITH
		ENDWITH

		RETURN

	endproc
	
ENDDEFINE
	
DEFINE CLASS cCancel as CommandButton
	CANCEL = .t.
	caption = "Cancel"
	PROCEDURE init
		this.Height = 25
		this.Top = thisform.height - this.Height - 5
		this.left = thisform.width - this.Width - 5
	endproc
	PROCEDURE click
		thisform.release
	ENDPROC
ENDDEFINE
