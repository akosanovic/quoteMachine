// Generated by CoffeeScript 1.10.0
(function() {
  var QuoteMachine;

  this.QuoteCard = (function() {
    function QuoteCard(JSONitem, counter) {
      this.cardJQuery = null;
      this.id = counter;
      this.content = JSONitem.quote;
      this.author = JSONitem.author;
      this.color = this._setCardColor();
    }

    QuoteCard.prototype.distroy = function() {
      this.cardJQuery = null;
      this.id = null;
      this.content = null;
      return this.author = null;
    };

    QuoteCard.prototype._setCardColor = function() {
      var color, colorArray, reminder;
      colorArray = ["blue", "pink", "purple", "orange", "green"];
      if (colorArray.length <= this.id) {
        reminder = this.id % colorArray.length;
        color = colorArray[reminder];
      } else {
        color = colorArray[this.id];
      }
      console.log("color id ", color);
      return color;
    };

    QuoteCard.prototype._getHTML = function() {
      var quoteContent;
      return quoteContent = "<div class='quoteCardContainer " + this.color + "'> <div class='quoteCard'> <div class='carouselNavigation-previous prev--button'> <div class='navArrowContainer'> <i class='fa fa-chevron-left' aria-hidden='true'></i> </div> </div> <div class='quoteContainer'> <div class='quote' data-cardID='" + this.id + "'> <div class='quoteContent display--quote'> " + this.content + " </div> <div class='quoteAuthor'> <span>Author: </span> " + this.author + " </div> </div> </div> <div class='carouselNavigation-next next--button'> <div class='navArrowContainer'> <i class='fa fa-chevron-right' aria-hidden='true'></i> </div> </div> </div> </div>";
    };

    QuoteCard.prototype.getQuoteCard = function() {
      this.cardJQuery = $(this._getHTML());
      return this.cardJQuery;
    };

    return QuoteCard;

  })();

  QuoteMachine = (function() {
    function QuoteMachine() {
      this.pageContainer = $('.page--container');
      this.cardContainer = this.pageContainer.find('.card--container');
      this.displayQuote = this.pageContainer.find('.display--quote');
      this.counter = 0;
      this.quoteCard = null;
      this.quoteArray = [];
      this.programmersQuotesURL = "http://quotes.stormconsultancy.co.uk/quotes.json";
      this._loadHandler();
      $(document).on('keydown', this._keypressHandler.bind(this));
      this.pageContainer.on('click', this._clickHandler.bind(this));
    }

    QuoteMachine.prototype._loadHandler = function() {
      return $.get(this.programmersQuotesURL, this._manageQuoteAPI.bind(this));
    };

    QuoteMachine.prototype._clickHandler = function(e) {
      var element, target;
      target = $(e.target);
      this.buttonNext = this.pageContainer.find('.next--button');
      element = target.closest(this.buttonNext);
      if (element.length > 0) {
        this._showNextQuote();
      }
      this.buttonPrevious = this.pageContainer.find('.prev--button');
      element = target.closest(this.buttonPrevious);
      if (element.length > 0) {
        return this._showPrevQuote();
      }
    };

    QuoteMachine.prototype._keypressHandler = function(e) {
      var keyPressed;
      keyPressed = e.keyCode;
      console.log("keyPressed ", keyPressed);
      if (keyPressed === 39) {
        this._showNextQuote();
      }
      if (keyPressed === 37) {
        return this._showPrevQuote();
      }
    };

    QuoteMachine.prototype._getQuoteItem = function() {
      var item, number, quoteArrayLength;
      quoteArrayLength = this.quoteArray.length;
      if (this.counter >= quoteArrayLength) {
        this.counter = 0;
        return this._getQuoteItem();
      } else if (quoteArrayLength > this.counter) {
        number = this.counter;
        item = this.quoteArray[number];
        console.log("@counter", this.counter);
        console.log("ITEM, ", item);
        return item;
      }
    };

    QuoteMachine.prototype._manageQuoteAPI = function(JSONdata) {
      var i, item, len;
      for (i = 0, len = JSONdata.length; i < len; i++) {
        item = JSONdata[i];
        this.quoteArray.push(item);
      }
      return this._createNewQuoteCard();
    };

    QuoteMachine.prototype._createNewQuoteCard = function() {
      var quoteItem, quoteObject;
      console.log("ayooo");
      quoteItem = this._getQuoteItem();
      console.log("Quote item", quoteItem, "counter ", this.counter);
      if (quoteItem) {
        if (quoteObject) {
          quoteObject = null;
          return this._createNewQuoteCard();
        } else {
          quoteObject = new QuoteCard(quoteItem, this.counter);
          this.quoteCard = quoteObject.getQuoteCard();
          this.counter++;
          return this.cardContainer.append(this.quoteCard);
        }
      }
    };

    QuoteMachine.prototype._destroyQuoteCard = function() {
      if (this.quoteCard) {
        this.quoteCard.remove();
        return this.quoteCard = null;
      }
    };

    QuoteMachine.prototype._showPrevQuote = function() {
      console.log("show prev quote");
      if (this.counter >= 2) {
        this.counter = this.counter - 2;
        if (this.quoteCard) {
          this._destroyQuoteCard();
          return this._createNewQuoteCard();
        }
      }
    };

    QuoteMachine.prototype._showNextQuote = function() {
      console.log("Show next quote");
      if (this.quoteCard) {
        this._destroyQuoteCard();
        return this._createNewQuoteCard();
      }
    };

    return QuoteMachine;

  })();

  $(function() {
    var quote;
    return quote = new QuoteMachine();
  });

}).call(this);
