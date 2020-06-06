"
I provide a configuration GUI for configuring and installing breakpoints.
I could become more generic and provide an debugging entry point for configuring debugging tools relying on the AST.
"
Class {
	#name : #UBConfigurationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'break',
		'beforeRadio',
		'afterRadio',
		'once',
		'count',
		'countInput',
		'entry',
		'return',
		'record',
		'recordStrategy',
		'trace',
		'traceStrategy',
		'metaAction',
		'metaActionStrategy',
		'condition',
		'conditionCode',
		'read',
		'write',
		'catchExceptions',
		'catchExceptionsStrategy',
		'toolBar',
		'menuButton'
	],
	#category : #UnifiedBreakpoints
}

{ #category : #specs }
UBConfigurationPresenter class >> breakSpec [
	^ SpBoxLayout newHorizontal
		add: #break withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #beforeRadio withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #afterRadio withConstraints: [ :constraints | constraints width: self labelWidth ];
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> catchExceptionsSpec [
	^ SpBoxLayout newHorizontal
		add: #catchExceptions withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #catchExceptionsStrategy;
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> conditionSpec [
	^ SpBoxLayout newVertical
		add: #condition" withConstraints: [ :constraints | constraints width: self labelWidth ]";
		add: #conditionCode;
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> countSpec [
	^ SpBoxLayout newHorizontal
		add: #once withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #count withConstraints: [ :constraints | constraints width: self labelWidth*0.66 ];
		add: #countInput withConstraints: [ :constraints | constraints width: self labelWidth*0.5 ];
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar expand: false fill: false padding: 0;
		add: (SpBoxLayout newVertical 
			add: 'Where to break?' expand: false fill: false padding: 5;
			add: self breakSpec expand: false fill: false padding: 5;
			add: self variableSpec expand: false fill: false padding: 5;
			add: self countSpec expand: false fill: false padding: 5;
			add: self methodSpec expand: false fill: false padding: 5; 
			yourself);
		add: (SpBoxLayout newVertical 
			add: 'When to break?' expand: false fill: false padding: 5;
			add: #condition expand: false fill: false padding: 0;
			add: #conditionCode withConstraints: [:c| c height: 100];
			"add: self conditionSpec expand: false fill: false padding: 5;"		
			yourself);
		add: (SpBoxLayout newVertical 
			add: 'Meta' expand: false fill: false padding: 5;
			add: self recordSpec expand: false fill: false padding: 5;
			add: self traceSpec expand: false fill: false padding: 5;
			add: self metaActionSpec expand: false fill: false padding: 5;
			add: self catchExceptionsSpec expand: false fill: false padding: 5;
			yourself);
		yourself
]

{ #category : #example }
UBConfigurationPresenter class >> example [
	<example>
	self new openWithSpec
]

{ #category : #specs }
UBConfigurationPresenter class >> metaActionSpec [
	^ SpBoxLayout newHorizontal
		add: #metaAction withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #metaActionStrategy;
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> methodSpec [
	^ SpBoxLayout newHorizontal
		add: #entry withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #return withConstraints: [ :constraints | constraints width: self labelWidth ];
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> recordSpec [
	^ SpBoxLayout newHorizontal
		add: #record withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #recordStrategy;
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> traceSpec [
	^ SpBoxLayout newHorizontal
		add: #trace withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #traceStrategy;
		yourself
]

{ #category : #specs }
UBConfigurationPresenter class >> variableSpec [
	^ SpBoxLayout newHorizontal
		add: #read withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: #write withConstraints: [ :constraints | constraints width: self labelWidth ];
		yourself
]

{ #category : #initialization }
UBConfigurationPresenter >> initializePresenters [
	break := self newCheckBox.
	break label: 'Break'.
	count := self newCheckBox.
	count label: 'Count'.
	once := self newCheckBox.
	once label: 'Once'.
	entry := self newCheckBox.
	entry label: 'Method entry'.
	return := self newCheckBox.
	return label: 'Method return'.
	catchExceptions := self newCheckBox.
	catchExceptions label: 'Catch errors'.
	write := self newCheckBox.
	write label: 'On write'.
	read := self newCheckBox.
	read label: 'On read'.
	record := self newCheckBox.
	record label: 'Record'.
	metaAction := self newCheckBox.
	metaAction label: 'Meta-action'.
	trace := self newCheckBox.
	trace label: 'Trace'.
	condition := self newCheckBox.
	condition label: 'Condition'.
	afterRadio := self newRadioButton.
	afterRadio label: 'After'.
	beforeRadio := self newRadioButton.
	beforeRadio label: 'Before'.
	conditionCode := self newCode.
	countInput := self newTextInput.
	traceStrategy := self newDropList.
	recordStrategy := self newDropList.
	metaActionStrategy := self newDropList.
	catchExceptionsStrategy := self newDropList.
	
	traceStrategy
		items: #('Transcript');
		display: [ :each | each ].
		
	recordStrategy
		items: #('Watch');
		display: [ :each | each ].
		
	metaActionStrategy
		items: #('Metaobject');
		display: [ :each | each ].
	
	catchExceptionsStrategy
		items: #('Default handler');
		display: [ :each | each ].
		
	toolBar := self newToolBar
			addItem: (SpToolBarButtonPresenter new
						label: 'Install';
						icon: (self iconNamed: #smallOk);
						help: 'Ok';
						action: [ self inform: 'Ok' ];
						yourself);
			addItem: (SpToolBarButtonPresenter new
						label: 'Remove';
						icon: (self iconNamed: #smallCancel);
						help: 'Cancel';
						action: [ self inform: 'Cancel' ];
						yourself);
			addItem:
			((menuButton := SpToolBarMenuButtonPresenter new)
			label: 'Configurations';
			icon: (self iconNamed: #history);
			action: [ UIManager default defer: [ self inform: menuButton label ] ];
			menu: [ 
				SpMenuPresenter new
					addGroup: [ :group | group
						addItem: [ :item | item 
							name: '1';
							action: [ menuButton label: item name ] ];
						addItem: [ :item | item 
							name: '2';
							action: [ menuButton label: item name ] ];
						addItem: [ :item | item 
							name: '3';
							action: [ menuButton label: item name ] ] ];
					yourself ]);
			yourself

]

{ #category : #initialization }
UBConfigurationPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Configure Breakpoint';
		initialExtent: 310 @ 600
]
