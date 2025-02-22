"
I'm a ""do it"" command. 
I will execute the selection (or line) of the playground.
"
Class {
	#name : 'SpCodeDoItCommand',
	#superclass : 'SpCodeSelectionCommand',
	#category : 'Spec2-Code-Commands-Base',
	#package : 'Spec2-Code-Commands',
	#tag : 'Base'
}

{ #category : 'accessing' }
SpCodeDoItCommand class >> defaultDescription [ 

	^ 'Evaluate selection.'
]

{ #category : 'default' }
SpCodeDoItCommand class >> defaultIconName [

	^ #smallDoIt
]

{ #category : 'default' }
SpCodeDoItCommand class >> defaultName [

	^ 'Do it'
]

{ #category : 'default' }
SpCodeDoItCommand class >> defaultShortcutKey [

	^ $d actionModifier
]

{ #category : 'accessing' }
SpCodeDoItCommand class >> order [

	^ 10
]

{ #category : 'execution' }
SpCodeDoItCommand >> execute [
	"Treat the current text selection as an expression; evaluate it."

	self evaluateSelectionAndDo: [ :result | ]
]
