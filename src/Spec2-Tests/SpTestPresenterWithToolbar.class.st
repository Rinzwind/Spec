"
A presenter with a tollbar and a button to use in Window / World tests.
"
Class {
	#name : 'SpTestPresenterWithToolbar',
	#superclass : 'SpPresenter',
	#instVars : [
		'button'
	],
	#category : 'Spec2-Tests-Core-Support',
	#package : 'Spec2-Tests',
	#tag : 'Core-Support'
}

{ #category : 'layout' }
SpTestPresenterWithToolbar class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpPanedLayout newTopToBottom
			add: #button;
			yourself);
		yourself
]

{ #category : 'layout' }
SpTestPresenterWithToolbar class >> defaultPreferredExtent [ 

	^ 700 @ 550
]

{ #category : 'initialization' }
SpTestPresenterWithToolbar >> initializePresenters [
	button := self newButton
		label: 'test';
		yourself.
]

{ #category : 'initialization' }
SpTestPresenterWithToolbar >> initializeWindow: aWindowPresenter [
	| toolbar |
	super initializeWindow: aWindowPresenter.
	toolbar := SpToolbarPresenter new
		addItemLeft: (SpToolbarButtonPresenter new
			label: 'toolbar button';
			yourself);
		yourself.
	aWindowPresenter
		toolbar: toolbar
]

{ #category : 'initialization' }
SpTestPresenterWithToolbar >> windowTitle [

	^  self class name
]
