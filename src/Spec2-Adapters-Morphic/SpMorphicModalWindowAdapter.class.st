"
I am a morphic adapter used to show a modal for a ModalWindowPresenter in Morphic.
"
Class {
	#name : 'SpMorphicModalWindowAdapter',
	#superclass : 'SpMorphicDialogWindowAdapter',
	#instVars : [
		'backdropMorph'
	],
	#category : 'Spec2-Adapters-Morphic-Base',
	#package : 'Spec2-Adapters-Morphic',
	#tag : 'Base'
}

{ #category : 'testing' }
SpMorphicModalWindowAdapter >> closeOnBackdropClick [

	^ self model closeOnBackdropClick
]

{ #category : 'private' }
SpMorphicModalWindowAdapter >> deleteBackdropMorph [

	backdropMorph ifNil: [ ^ self ]. 
	backdropMorph delete.
	backdropMorph := nil
]

{ #category : 'event handling' }
SpMorphicModalWindowAdapter >> mouseClick: evt onBackdrop: aMorph [

	self closeOnBackdropClick ifFalse: [ ^ self ].

	self model triggerCancelAction.
	self model close. "Ensure the modal is closed"
	aMorph delete
]

{ #category : 'protocol' }
SpMorphicModalWindowAdapter >> openWithDeferredAction: aBlock [

	backdropMorph := FullscreenMorph new
		                 color: self theme modalBackdropColor;
		                 on: #click send: #mouseClick:onBackdrop: to: self;
		                 openInWorld;
		                 yourself.

	self widget beSticky.
	"I am copying here what is defined in SystemWindow>>#openModal (but introducing the centered 
	 check inbetween because #openInWorld will use the RealEstateAgent to position the window 
	 and we want to (maybe) center it before showing it."
	self widget openInWorld.
	self centerIfNeeded.
	self presenter windowIsOpened.
	aBlock value.
	self waitWhile: [ self widget isInWorld ]
]

{ #category : 'private' }
SpMorphicModalWindowAdapter >> waitWhile: aBlock [
	
	MorphicRenderLoop new doOneCycleWhile: aBlock
]

{ #category : 'updating' }
SpMorphicModalWindowAdapter >> windowClosed [

	self deleteBackdropMorph.
	super windowClosed
]
