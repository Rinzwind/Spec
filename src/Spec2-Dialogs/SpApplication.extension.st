Extension { #name : 'SpApplication' }

{ #category : '*Spec2-Dialogs' }
SpApplication >> alert: aString [
	"Displays an inform dialog, for more configurable version please use `self application newInform title: ....`."

	^ self newAlert
		  title: 'Alert';
		  label: aString;
		  openModal
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> confirm: aString [
	"Displays a confirm dialog, for more configurable version please use `self application newConfirm title: ....`."

	^ self newConfirm
		  title: 'Please confirm';
		  label: aString;
		  openModal
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> inform: aString [

	^ self backend inform: aString
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> informUser: aString during: aBlock [
	"Displays an inform user dialog."
	| result |

	result := nil.
	Job new
		title: aString;
		block: [ :job | 
			"job min: 0; max: 100."
			result := aBlock cull: job ];
		run.

	^ result
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> jobList [

	^ self 
		propertyAt: #jobList 
		ifAbsentPut: [ self newJobList ]
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newAlert [

	^ SpAlertDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newConfirm [

	^ SpConfirmDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newInform [

	^ SpInformDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newInformUser [

	^ SpInformUserDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newJobList [

	^ SpJobListPresenter newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newOpenFile [
		
	^ SpFileDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newRequest [

	^ SpRequestDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newRequestText [

	^ SpRequestTextDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newSelect [

	^ SpSelectDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> newSelectMultiple [

	^ SpSelectMultipleDialog newApplication: self
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> notificationClass [ 

	^ SpNotificationItem
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> notify: aString [

	self notificationCenter add: (self notificationClass with: aString)
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> selectDirectoryTitle: aString [

	^ self newOpenFile 
		title: aString;
		beOpenDirectory;
		openModal
]

{ #category : '*Spec2-Dialogs' }
SpApplication >> selectFileTitle: aString [

	^ self newOpenFile
		title: aString;
		openModal
]
