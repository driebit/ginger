$.widget("ui.search_suggestions", {

    _init: function() {
        this.init();
    },

    init: function() {
        // Initial model
        this.model = {
            index: -1,
            suggestions: [],
            input: ''
        }

        // Zotonic wire ID that sends search value
        this.suggestionsWire = this.element.data('param-wire');

        // Set Viewport height
        this.windowHeight = $(window).height();

        // Set suggestions element
        var suggestionsElementId = this.element.data('param-results');
        this.suggestionsElement = $('#' + suggestionsElementId);

        // Set search form toggle element
        var toggleButtonId = this.element.data('param-togglebutton');
        this.toggleButtonElement = $('#' + toggleButtonId);

        // Set form element
        this.formElement = this.element.closest('form');

        // Initialize MutationObserver
        this._observeSuggestions();

        // Attach EventListeners
        this._attachEventListeners();

        // Don't know why this was here... yet
        // this.suggestionsElement.removeClass('is-scrolable');
        // this.suggestionsElement.hide();
    },

    update: function(type, value) {
        switch (type) {
            case 'SetSuggestions':
                this.model.index = -1;
                this.model.suggestions = Array.prototype.slice.call(value);
                this._render();
                break;

            case 'MoveDown':
                if (this.model.index === this.model.suggestions.length - 1) {
                    this.model.index = 0;
                } else {
                    this.model.index = this.model.index + 1;
                    this.model.value = value;
                }
                this._render();
                break;

            case 'MoveUp':
                if (this.model.index === -1) {
                        this.model.index = this.model.suggestions.length - 1;
                } else {
                    this.model.index = this.model.index - 1;
                    this.model.value = value;
                }
                this._render();
                break;

            case 'SetInput':
                this.model.input = value;

                if (value.trim() !== '') {
                    this._getSuggestions(value);
                    this.suggestionsElement.show();
                } else {
                    this.suggestionsElement.hide();
                }
                break;
        }
    },

    _render: function() {
        this._removeHighlight();

        if (this.model.index === -1 || this.model.suggestions.length === 0) {
            return;
        }

        this.model.suggestions[this.model.index].style.textDecoration = 'underline';
        this.model.suggestions[this.model.index].style.fontWeight = '800';

        this.element[0].value = this.model.suggestions[this.model.index].textContent.trim();
    },


    _attachEventListeners: function() {
        var document = $(document);

        document.on('search:close', this._closeSearch.bind(this));

        document.on('search:toggle', this._toggleSearch.bind(this));

        document.on('keyup', function(e) {
            if (e.keyCode === 13) {
                this._closeSearch();
            }
        }.bind(this));

        this.element.on('keyup', function(e) {
            var key = e.keyCode;
            var inputValue = e.currentTarget.value;

            if (key === 38) {
                this.update('MoveUp', inputValue);
            } else if (key === 40) {
                this.update('MoveDown', inputValue);
            } else if (key === 27) {
                this._closeSearch();
            } else {
                this.update('SetInput', inputValue);
            }
        }.bind(this));

        if (this.toggleButtonElement !== undefined) {
            this.toggleButtonElement.on('click', this._toggleSearch.bind(this));
        }
    },

        _getSuggestions: function() {
        z_event(this.suggestionsWire, {value: this.model.input});

        if (this.suggestionsElement.outerHeight() > this.windowHeight) {
            this.suggestionsElement.addClass('is-scrollable');
        }
    },

    _observeSuggestions: function() {
        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                this.update('SetSuggestions', mutation.target.querySelectorAll('a'));
            }.bind(this));
        }.bind(this));

        // configuration of the observer:
        var config = { attributes: true, childList: true, characterData: true };

        // pass in the target node, as well as the observer options
        observer.observe(this.suggestionsElement[0], config);
    },

    _removeHighlight: function() {
        this.model.suggestions.forEach(function(x) {
            x.style.textDecoration = 'none';
            x.style.fontWeight = '400';
        });
    },

    _closeSearch: function(event) {
        this._toggleSearch(event, true);
    },

    _toggleSearch: function(event, close) {
        if (this.toggleButtonElement) {
            this.toggleButtonElement.toggleClass('is-active');
        }

        if (close) {
            this.suggestionsElement.hide();
            this.formElement.removeClass('is-visible');
            if (this.toggleButtonElement) this.toggleButtonElement.removeClass('is-active');
        } else {
            this.formElement.toggleClass('is-visible');
        }

        this.element.val('');
        this.suggestionsElement.hide();

        if (this._isVisible()) {
            this.formElement.on('transitionend', function () {
                this.element.focus();
            }.bind(this));
        }

        $(document).trigger('search:toggled');

        return false; // Don't know about this
    },

    _isVisible: function() {
        return this.suggestionsElement.css('display') === 'block' ||
        this.formElement.hasClass('is-visible');
    }
});

