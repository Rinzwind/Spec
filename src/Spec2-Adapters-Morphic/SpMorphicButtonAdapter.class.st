"
SpecInterpreter
	interpretASpec: MorphicButtonAdapter  defaultSpec
	model: (MorphicButtonAdapter model: ButtonPresenter new)

"
Class {
	#name : 'SpMorphicButtonAdapter',
	#superclass : 'SpAbstractMorphicAdapter',
	#instVars : [
		'subMenuWidget',
		'styleName'
	],
	#category : 'Spec2-Adapters-Morphic-Base',
	#package : 'Spec2-Adapters-Morphic',
	#tag : 'Base'
}

{ #category : 'widget API' }
SpMorphicButtonAdapter >> action [

	"self showSubMenuIfPresent."

	self widget ifNotNil: [:m | m takeKeyboardFocus ].
	self model performAction
]

{ #category : 'protocol' }
SpMorphicButtonAdapter >> askBeforeChanging [

	^ self model askBeforeChanging
]

{ #category : 'private' }
SpMorphicButtonAdapter >> buildLabel: text withIcon: icon [
	| iconLabel |

	icon ifNil: [ 
		^ (text localizedForPresenter: self presenter) ifNil: [ '' ] ].
	
	iconLabel := IconicListItemMorph new.
	iconLabel icon: (self presenter isEnabled
		ifTrue: [ icon ]
		ifFalse: [ icon asGrayScaleWithAlpha ]).
	text isEmptyOrNil ifFalse: [ 
		iconLabel morph: (text asMorph 
			lock;
			yourself) ].
		
	^ iconLabel
]

{ #category : 'factory' }
SpMorphicButtonAdapter >> buildWidget [
	| button | 

	button := self newButton.	
	button 
		getEnabledSelector: #enabled ;
		getFontSelector: #font ;
		hResizing: #spaceFill ;
		vResizing: #spaceFill ;
		askBeforeChanging: self askBeforeChanging ;
		setBalloonText: self getHelpText ;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled ;	
		eventHandler: (MorphicEventHandler new 
			on: #keyStroke 
			send: #keyStroke:fromMorph: 
			to: self).
	
	self color ifNotNil: [ self setWidgetColor: button ].
	
	button 
		bindKeyCombination: Character space 
		toAction: [ self action ].

	^ button
]

{ #category : 'emulating' }
SpMorphicButtonAdapter >> clicked [

	| evt |
	evt := MouseButtonEvent new
		       setType: nil
		       position: widget center
		       which: MouseButtonEvent redButton
		       buttons: MouseButtonEvent redButton
		       hand: nil
		       stamp: nil.

	(widget handlesMouseDown: evt) ifTrue: [ 
		widget 
			mouseDown: evt;
			mouseUp: evt ]
]

{ #category : 'menus support' }
SpMorphicButtonAdapter >> deleteIfPopUp: evt [
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> enabled: aBoolean [

	super enabled: aBoolean.
	self widgetDo: [ :w | w label: self label ]
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> font [

	^ self model font
]

{ #category : 'private' }
SpMorphicButtonAdapter >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'private' }
SpMorphicButtonAdapter >> getLabelText [

	^ self presenter label ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> helpText [

	^ self widget helpText
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> icon [

	^ widget label icon
]

{ #category : 'menus support' }
SpMorphicButtonAdapter >> isSelected: aBooolean [
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> keyStroke: anEvent fromMorph: aMorph [
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> label [
	| labelString |
	
	labelString := self presenter label 
		ifNotNil: [ :aString | aString withAccentuatedCharacter: self presenter shortcutCharacter ].
	
	^ self 
		buildLabel: labelString 
		withIcon: self presenter icon
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> menu: aMenu [
	| menuPresenter |
	
	"apply actions"
	self presenter actions ifNotNil: [ :actions |
		menuPresenter := self presenter newMenu.
		menuPresenter fillWith: actions ].
	"apply context menu if there is one"
	self presenter contextMenu ifNotNil: [ :aContextMenu | 
		self presenter actions ifNotNil: [ 
			Error signal: 'You are using contextMenu: and actions: at the same time. Both mechanisms are mutually exclusive.' ].
		menuPresenter := aContextMenu ].
	
	menuPresenter ifNil: [ ^ nil ].
	
	^ SpBindings
		  value: self presenter application adapterBindings
		  during: [ menuPresenter value build ]
]

{ #category : 'factory' }
SpMorphicButtonAdapter >> newButton [

	^ SpPluggableButtonMorph
		  on: self
		  getState: #state
		  action: #action
		  label: #label
		  menu: #menu:
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> setAsDefault [

	self widget isDefault: true
]

{ #category : 'factory' }
SpMorphicButtonAdapter >> setWidgetColor: button [

	| normalColorBlock clickedColorBlock |

	normalColorBlock := [ :aButton |
			(aButton valueOfProperty: #noFill ifAbsent: [false]) 
					ifTrue: [ SolidFillStyle color: Color transparent ]
					ifFalse: [ SolidFillStyle color: self color ] ].
	
	clickedColorBlock := [ :aButton | SolidFillStyle color: self color muchDarker ].
	button theme: ((SpUIThemeDecorator theme: button theme)
							property: #buttonNormalFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonMouseOverFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonPressedFillStyleFor: returnsValueOf: clickedColorBlock;
							yourself)
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> showSubMenu: aMenu [

	aMenu menuGroups ifNil: [ ^ self ].

	subMenuWidget ifNotNil: [ 
		subMenuWidget delete.
		subMenuWidget := nil ].
	subMenuWidget := (SpMorphicMenuAdapter adaptAsPopup: aMenu) widget.
	subMenuWidget
		popUpAdjacentTo: { 
				self widget bounds bottomLeft.
				self widget bounds bottomRight }
		forHand: self widget activeHand
		from: self widget.
	subMenuWidget popUpOwner: self
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> showSubMenuIfPresent [
	| menuPresenter |

	"apply actions"
	self presenter actions ifNotNil: [ :actions |
		menuPresenter := self presenter newMenu.
		menuPresenter fillWith: actions ].
	"apply context menu if there is one"
	self presenter contextMenu ifNotNil: [ :aContextMenu | 
		self presenter actions ifNotNil: [ 
			Error signal: 'You are using contextMenu: and actions: at the same time. Both mechanisms are mutually exclusive.' ].
		menuPresenter := aContextMenu ].

	self presenter actions ifNil: [ ^ self ].
	self showSubMenu: menuPresenter
]

{ #category : 'widget API' }
SpMorphicButtonAdapter >> state [

	^ self model state
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> styleName [

	^ styleName ifNil: [ super styleName ]
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> styleName: aString [ 

	styleName := aString
]

{ #category : 'accessing' }
SpMorphicButtonAdapter >> unscaledInitialExtent [

	^ 15@26
]

{ #category : 'updating' }
SpMorphicButtonAdapter >> updateMenu [	
	"There is no need to updateMenu here because it will be resolved at #menu:"
]
