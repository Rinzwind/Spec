"
A simple dialog to request some information (a text)
"
Class {
	#name : 'SpRequestDialog',
	#superclass : 'SpAbstractCancelableMessageDialog',
	#instVars : [
		'textInput',
		'validateBlock',
		'errorLabel'
	],
	#category : 'Spec2-Dialogs',
	#package : 'Spec2-Dialogs'
}

{ #category : 'accessing' }
SpRequestDialog class >> defaultPreferredExtent [

	^ 450@170
]

{ #category : 'documentation' }
SpRequestDialog class >> documentFactoryMethodSelector [
	
	^ #newRequest
]

{ #category : 'examples' }
SpRequestDialog class >> example [

	| presenter |
	presenter := self new.
	presenter
		title: 'Request example';
		label: 'The meaning of life?';
		text: 'I am tempted to say 42...';
		acceptLabel: 'I know!';
		cancelLabel: 'Cancel';
		onAccept: [ :dialog | dialog presenter inform: dialog presenter text ];
		openDialog
]

{ #category : 'examples' }
SpRequestDialog class >> exampleModal [

	| string presenter |
	presenter := self new.
	string := presenter
		          title: 'Request modal example';
		          label: 'The meaning of life?';
		          text: 'I am tempted to say 42...';
		          acceptLabel: 'I know!';
		          cancelLabel: 'Cancel';
		          openModal.

	string ifNotNil: [ presenter inform: string ]
]

{ #category : 'examples' }
SpRequestDialog class >> exampleMultiLineLabel [ 

	| presenter label |

	label := String streamContents: [ :s |
		s nextPutAll: 'The meaning of life?';
		  cr;
		  cr;
		  nextPutAll: 'Something else two lines bellow with a really long long long long text that will wrap'
		 ].	

	presenter := self new.
	presenter
		title: 'Request example';
		label: label;
		text: 'I am tempted to say 42...';
		acceptLabel: 'I know!';
		cancelLabel: 'Cancel';
		onAccept: [ :dialog | dialog presenter inform: dialog presenter text ];
		openDialog
]

{ #category : 'examples' }
SpRequestDialog class >> examplePassword [

	self new
		bePassword;
		title: 'Secret request example';
		label: 'The meaning of life?';
		text: 'I am tempted to say 42...';
		acceptLabel: 'I know!';
		cancelLabel: 'Cancel';
		onAccept: [ :dialog | dialog presenter inform: dialog presenter text ];
		openDialog
]

{ #category : 'private' }
SpRequestDialog >> accept [

	self validateAnswer ifFalse: [ ^ self ].
	super accept
]

{ #category : 'api' }
SpRequestDialog >> bePassword [

	textInput bePassword
]

{ #category : 'api' }
SpRequestDialog >> beText [

	textInput beText
]

{ #category : 'initialization' }
SpRequestDialog >> connectPresenters [ 

	super connectPresenters.

	textInput 
		addShortcutWith: [ :action | action 
			shortcutKey: Character cr asKeyCombination;
			action: [ self accept ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: Character escape asKeyCombination;
			action: [ self cancel ] ]
]

{ #category : 'layout' }
SpRequestDialog >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
				add: (SpBoxLayout newTopToBottom
					vAlignStart;
					add: image;
					yourself)
				expand: false;
				add: label expand: true;
				yourself) 
			height: self calculateLabelHeight;
		add: textInput expand: false;
		add: errorLabel;
		yourself
]

{ #category : 'accessing' }
SpRequestDialog >> defaultTitle [

	^ 'Request'
]

{ #category : 'api' }
SpRequestDialog >> entryCompletion: anEntryCompletion [

	textInput entryCompletion: anEntryCompletion
]

{ #category : 'initialization' }
SpRequestDialog >> initializePresenters [

	super initializePresenters.

	textInput := self newTextInput.
	errorLabel := self newLabel.
]

{ #category : 'initialization' }
SpRequestDialog >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter whenOpenedDo: [ textInput takeKeyboardFocus; selectAll  ]
]

{ #category : 'testing' }
SpRequestDialog >> isPassword [
	
	^ textInput isPassword
]

{ #category : 'api - showing' }
SpRequestDialog >> openModal [
	| dialog |
	
	dialog := super openModal.
	^ dialog isOk
		ifTrue: [ self text trimmed ]
		ifFalse: [ nil ]
]

{ #category : 'initialization' }
SpRequestDialog >> setErrorText: aText [

	errorLabel label: aText.
]

{ #category : 'api' }
SpRequestDialog >> text [ 
	
	^ textInput text trimmed
]

{ #category : 'api' }
SpRequestDialog >> text: aString [

	textInput text: aString
]

{ #category : 'private' }
SpRequestDialog >> validateAnswer [
	
	| result |
	
	validateBlock ifNotNil: [ 
		result := validateBlock cull: textInput text cull: self.
		result ifFalse: [ textInput takeKeyboardFocus ].
		^ result].
	
	
	^ true
]

{ #category : 'api' }
SpRequestDialog >> validateAnswer: aBlock [

	validateBlock := aBlock
]
