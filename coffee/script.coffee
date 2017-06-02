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
			"<div class='quoteCardContainer quote--card--container #{@color}'>

				<div class='socialMediaShareButtonsContainer'>
					<!-- Facebook share button code -->
					<div class='fb-share-button ' data-href='https://codepen.io/alkos/pen/MmNdNa?editors=1010' data-layout='button' data-size='small' data-mobile-iframe='true'>
						<a class='fb-xfbml-parse-ignore' target='_blank' href='https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fplugins%2F&amp;src=sdkpreparse'>
							Share
						</a>
					</div>

				</div>


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
		@currentHref = @_getHref()


		@quoteArray = [];
		@hrefArray = [];


		@programmersQuotesURL = "http://quotes.stormconsultancy.co.uk/quotes.json"



		# event handlers
		@_loadHandler()
		$(window).on('hashchange', @_hashChangeHandler.bind(@))
		$(document).on('keydown', @_keypressHandler.bind(@))
		@pageContainer.on('click', @_clickHandler.bind(@))






	# Event handling functions :: BEGIN
	_loadHandler: () ->
		# get programmers quotes
		$.get(@programmersQuotesURL, @_manageQuoteAPI.bind(@) )
		

	_hashChangeHandler:() ->

		href = @_getHref()
		if href
			@_createNewQuoteCard()


	_clickHandler: (e) ->
		target = $(e.target)
	
		
		@buttonNext = @pageContainer.find('.next--button')
		# clicked on next button - shows next quote
		element = target.closest(@buttonNext)
		if element.length > 0
			@_nextHref()
			
		
		# click on previous button - shows previous quote
		@buttonPrevious = @pageContainer.find('.prev--button')
		element = target.closest(@buttonPrevious)
		if element.length > 0
			@_previousHref()
			



	_keypressHandler: (e) ->
		keyPressed = e.keyCode
		console.log "keyPressed ", keyPressed
		
		# if right arrow clicked show next quote
		if keyPressed == 39
			@_nextHref()
			
		# if left arrow clicked show prev quote
		if keyPressed == 37
			@_previousHref()

	# Event handling functions :: END







	_getQuoteItem: () ->

		hrefCardID = @_getHref()
		
		for cardItem in @quoteArray
			if String(cardItem['id']) == hrefCardID
				
				item = cardItem
				console.log "ITEM, ", item
			
				return item
		
		# if end of quote array is reached
		# if user reverses sliding
		



	_manageQuoteAPI: (JSONdata) ->
		for item in JSONdata
			@hrefArray.push(item['id'])
			@quoteArray.push(item)
		@_restartHref()
		






	_getHref: () ->
		# eg: hash = #post-id=20
		hash = window.location.hash
		hashPairs = hash.split('=')
		hrefID = hashPairs[1]

		return hrefID



	_setHref: (hash) ->
		window.location.hash = "#post-id="+hash



	_restartHref: () ->
		href = @_getHref()
		if !href
			@currentHref = @hrefArray[0]
			console.log "RESTART HREF", @currentHref
			@_setHref(@currentHref)
		else 
			@_createNewQuoteCard()



	_nextHref: () ->
		console.log "NEXT HREF", @currentHref
		if not @currentHref
			@_restartHref()
		else
			indexOfCurrentHref = @hrefArray.indexOf(@currentHref)
			
			# if the max index is not reached
			if indexOfCurrentHref == @hrefArray.length-1
				console.log "Max index of href array reached", indexOfCurrentHref
				indexOfCurrentHref = -1
			
			indexOfNextHref = indexOfCurrentHref+=1
			# change current hreff, set it to next in line
			@currentHref = @hrefArray[indexOfNextHref]
			@_setHref(@currentHref)
		


	_previousHref: () ->
		console.log "PREV HREF"
		if not @currentHref
			@_restartHref()

		else 
			indexOfCurrentHref = @hrefArray.indexOf(@currentHref)
			# if the start of the href is reached restart it
			if indexOfCurrentHref == 0
				indexOfCurrentHref = @hrefArray.length

			indexOfPrevHref = indexOfCurrentHref-=1
			# change current hreff, set it to next in line
			@currentHref = @hrefArray[indexOfPrevHref]
			@_setHref(@currentHref)






	_createNewQuoteCard: () ->
		console.log "ayooo"
		quoteItem = @_getQuoteItem()
		console.log "Quote item", quoteItem, "counter ", @counter
		
		if @quoteCard
			@_destroyQuoteCard()
			@_createNewQuoteCard()


		else if quoteItem
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
			


	# _showPrevQuote: () ->
	# 	console.log "show prev quote"		
	# 	if @counter >= 2
	# 		@counter = @counter - 2
	# 		if @quoteCard
	# 			@_destroyQuoteCard()
	# 			@_createNewQuoteCard()



	# _showNextQuote: () ->
	# 	console.log "Show next quote"
	# 	if @quoteCard
	# 		@_destroyQuoteCard()
	# 		@_createNewQuoteCard()














$ ->
	quote = new QuoteMachine()