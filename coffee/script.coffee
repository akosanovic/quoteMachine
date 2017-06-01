class @QuoteCard
	constructor: (JSONitem, counter) ->
		@cardJQuery = null


		@id      = counter;
		@content = JSONitem.quote;
		@author  = JSONitem.author;
		@color   = @_setCardColor()





	distroy: () ->
		@cardJQuery = null
		@id      = null;
		@content = null;
		@author  = null;

	
	_setCardColor: () ->
		colorArray = ["blue", "pink", "purple", "orange", "green"]
		


		if colorArray.length <= @id
			reminder = @id % colorArray.length
			color = colorArray[reminder]
		else 
			color = colorArray[@id]
		console.log "color id ", color
		return color


	_getHTML: () ->
		quoteContent = 
			"<div class='quoteCardContainer #{@color}'>
				<div class='quoteCard'>

					<div class='carouselNavigation-previous prev--button'>
						<div class='navArrowContainer'>
							<i class='fa fa-chevron-left' aria-hidden='true'></i>
						</div>
					</div>
					<div class='quoteContainer'>


						<div class='quote' data-cardID='#{@id}'>
							<div class='quoteContent display--quote'>
								#{@content}
							</div>
							<div class='quoteAuthor'>
								<span>Author: </span> #{@author}
							</div>
						</div>
					</div>
					
					<div class='carouselNavigation-next next--button'>
						<div class='navArrowContainer'>
							<i class='fa fa-chevron-right' aria-hidden='true'></i>
						</div>
					</div>


				</div>
			</div>"



	getQuoteCard: () ->

		@cardJQuery = $(@_getHTML())
		return @cardJQuery




















class QuoteMachine
	constructor: () ->
		# jQuery elements that exist on page
		@pageContainer = $('.page--container')
		@cardContainer = @pageContainer.find('.card--container')
		
		
		@displayQuote   = @pageContainer.find('.display--quote')


		# helper variables & object holders
		@counter = 0;
		@quoteCard = null;
		@quoteArray = [];

		@programmersQuotesURL = "http://quotes.stormconsultancy.co.uk/quotes.json"



		# event handlers
		@_loadHandler()
		$(document).on('keydown', @_keypressHandler.bind(@))
		@pageContainer.on('click', @_clickHandler.bind(@))

		





	# Event handling functions :: BEGIN
	_loadHandler: () ->
		# get programmers quotes
		$.get(@programmersQuotesURL, @_manageQuoteAPI.bind(@) )
		
		

	_clickHandler: (e) ->
		target = $(e.target)
	
		
		@buttonNext = @pageContainer.find('.next--button')
		# clicked on next button - shows next quote
		element = target.closest(@buttonNext)
		if element.length > 0
			@_showNextQuote()
		
		# click on previous button - shows previous quote
		@buttonPrevious = @pageContainer.find('.prev--button')
		element = target.closest(@buttonPrevious)
		if element.length > 0
			@_showPrevQuote()



	_keypressHandler: (e) ->
		keyPressed = e.keyCode
		console.log "keyPressed ", keyPressed
		
		# if right arrow clicked show next quote
		if keyPressed == 39
			@_showNextQuote()
		# 
		if keyPressed == 37
			@_showPrevQuote()
	# Event handling functions :: END







	_getQuoteItem: () ->
		quoteArrayLength = @quoteArray.length
		if @counter >= quoteArrayLength
			@counter = 0
			@_getQuoteItem()
		
		else if quoteArrayLength > @counter
			number = @counter
			item = @quoteArray[number]
			
			console.log "@counter", @counter
			console.log "ITEM, ", item
			
			return item
		
		# if end of quote array is reached
		# if user reverses sliding
		



	_manageQuoteAPI: (JSONdata) ->
		for item in JSONdata
			@quoteArray.push(item)
		@_createNewQuoteCard()


	_createNewQuoteCard: () ->
		console.log "ayooo"
		quoteItem = @_getQuoteItem()
		console.log "Quote item", quoteItem, "counter ", @counter
		
		if quoteItem
			if quoteObject
				quoteObject = null
				@_createNewQuoteCard()
			else
				quoteObject = new QuoteCard( quoteItem, @counter )
				
				@quoteCard = quoteObject.getQuoteCard()

				@counter++
				@cardContainer.append(@quoteCard)
		


	_destroyQuoteCard: () ->
		if @quoteCard 
			@quoteCard.remove();
			@quoteCard = null
			


	_showPrevQuote: () ->
		console.log "show prev quote"		
		if @counter >= 2
			@counter = @counter - 2
			if @quoteCard
				@_destroyQuoteCard()
				@_createNewQuoteCard()



	_showNextQuote: () ->
		console.log "Show next quote"
		if @quoteCard
			@_destroyQuoteCard()
			@_createNewQuoteCard()














$ ->
	quote = new QuoteMachine()