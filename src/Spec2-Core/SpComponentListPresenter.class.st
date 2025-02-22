"
A presenter to show a dynamic list of presenters. 
When you do not have a list of elements that can be presented as a single list or table, it is possible to display a collection of presenters as a list using this component.

"
Class {
	#name : 'SpComponentListPresenter',
	#superclass : 'SpAbstractListPresenter',
	#category : 'Spec2-Core-Widgets-Table',
	#package : 'Spec2-Core',
	#tag : 'Widgets-Table'
}

{ #category : 'specs' }
SpComponentListPresenter class >> adapterName [
	^ #ComponentListAdapter
]

{ #category : 'documentation' }
SpComponentListPresenter class >> documentFactoryMethodSelector [

	^ #newComponentList
]

{ #category : 'initialization' }
SpComponentListPresenter >> addPresenter: aPresenter [
	
	aPresenter owner: self.
	self model add: aPresenter
]

{ #category : 'private' }
SpComponentListPresenter >> doActivateAtIndex: index [
	
	"Activate only if there is an item at that position"
	activationBlock  ifNil: [ ^ self ].
	self presenters at: index ifAbsent: [ ^ self ].
	
	activationBlock cull: ((SpSingleSelectionMode on: self)
		basicSelectIndex: index;
		yourself)
]

{ #category : 'testing' }
SpComponentListPresenter >> includes: aPresenter [
	"Answer true when the presenter includes `aPresenter` as part of its items." 

	^ self presenters includes: aPresenter  
]

{ #category : 'testing' }
SpComponentListPresenter >> isEmpty [
	"Answer true if presenter list is empty."	

	^ self presenters isEmpty
]

{ #category : 'api' }
SpComponentListPresenter >> items: aSequenceableCollection [ 
	"Set the items of the list. 
	 `aSequenceableCollection` is a list of presenters OR a list of elements that understand 
	 the method `#asPresenter`."
	
	^ super items: (aSequenceableCollection collect: [ :each | 
		each asPresenter
			owner: self;
			yourself ])
]

{ #category : 'api' }
SpComponentListPresenter >> presenters [
	"Answer the presenters of the list.
	 This is a synonym of `SpAbstractListPresenter>>#items`"

	^ self items
]

{ #category : 'api' }
SpComponentListPresenter >> presenters: aSequenceableCollection [ 
	"Set the list of presenters that will be the items to show in the component list.
	 This is a synonym of `SpAbstractListPresenter>>#items:`
	 See `SpAbstractListPresenter>>#model:`"
	
	^ self items: aSequenceableCollection
]

{ #category : 'api - events' }
SpComponentListPresenter >> whenPresentersChangedDo: aBlock [
	"Inform when the presenter list changed (See `SpComponentListPresenter>>#presenters:`.
	 `aBlock` receive 3 optional arguments: 
	 - new value 
	 - old value 
	 - announcement triggered"
	
	self whenModelChangedDo: aBlock
]
