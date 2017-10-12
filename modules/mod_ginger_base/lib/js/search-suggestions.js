$.widget("ui.search_suggestions", {

    _init: function() {
        // Initial model
        this.model = {
            index: -1,
            suggestions: [],
            input: '',
            viewPortHeight: $(window).height()
        }

        // Zotonic wire ID that sends search value
        this.suggestionsWire = this.element.data('param-wire');

        // Set suggestions element
        var suggestionsElementId = this.element.data('param-results');
        this.suggestionsElement = $('#' + suggestionsElementId);

        // Hide suggestions by default
        this.suggestionsElement.hide();

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
    },

    // If possible update the model through by use of this function
    _update: function(type, value) {
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
        // Reset all applied styles
        this._removeHighlight();

        // Test if selection is at the end of the suggestion list
        if (this.model.index === -1 || this.model.suggestions.length === 0) {
            return;
        }

        // Style/highlight selected element
        this.model.suggestions[this.model.index].style.textDecoration = 'underline';
        this.model.suggestions[this.model.index].style.fontWeight = '800';
        this.model.suggestions[this.model.index].scrollIntoView({block: "end"});

        // Change the input value to the selected suggestion value
        this.element[0].value = this.model.suggestions[this.model.index].textContent.trim();
    },

    _attachEventListeners: function() {
        var document = $(document);
        var mainElement = $('main');

        document.on('touchend', this._hideInputElement.bind(this));

        document.on('search:toggle', this._toggleInputElementVisibility.bind(this));

        document.on('keyup', function(event) {
            if (event.keyCode === 13) {
                this._hideInputElement();
            }
        }.bind(this));

        mainElement.on('click', this._hideInputElement.bind(this));

        this.element.on('keyup', function(e) {
            var key = e.keyCode;
            var inputValue = e.currentTarget.value;

            if (key === 38) {
                this._update('MoveUp', inputValue);
            } else if (key === 40) {
                this._update('MoveDown', inputValue);
            } else if (key === 27) {
                this._hideInputElement();
            } else {
                this._update('SetInput', inputValue);
            }
        }.bind(this));

        this.formElement.on('transitionend', this._focusFormElement.bind(this));

        if (this.toggleButtonElement !== undefined) {
            this.toggleButtonElement.on('click', this._toggleInputElementVisibility.bind(this));
        }
    },

    // Send input value over Zotonic wire
    _getSuggestions: function() {
        z_event(this.suggestionsWire, { value: this.model.input });

        if (this.suggestionsElement.outerHeight() > this.model.viewPortHeight) {
            this.suggestionsElement.addClass('is-scrollable');
        }
    },

    // Observe suggestions element for changes rendered by Zotonic
    _observeSuggestions: function() {
        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                this._update('SetSuggestions', mutation.target.querySelectorAll('a'));
            }.bind(this));
        }.bind(this));

        // Configuration of the observer:
        var config = { attributes: true, childList: true, characterData: true };

        // Pass in the target node, as well as the observer options
        observer.observe(this.suggestionsElement[0], config);
    },

    _removeHighlight: function() {
        this.model.suggestions.forEach(function(x) {
            x.style.textDecoration = 'none';
            x.style.fontWeight = '400';
        });
    },

    _hideInputElement: function(event) {
        this._toggleInputElementVisibility(event, true);
    },

    _focusFormElement: function() {
        if (this.isVisible()) {
            this.element.focus();
        }
    },

    _toggleInputElementVisibility: function(event, hideElement) {
        if (this.toggleButtonElement !== undefined) {
            if (hideElement) {
                this.toggleButtonElement.removeClass('is-active');
            } else {
                this.toggleButtonElement.toggleClass('is-active');
            }
        }

        if (hideElement) {
            this.formElement.removeClass('is-visible');
        } else {
            this.formElement.toggleClass('is-visible');
        }

        $(document).trigger('search:toggled');

        this.suggestionsElement.hide();
        this.element.val('');
    },

    // Public method to check if suggestions element is visible
    isVisible: function() {
        return this.suggestionsElement.css('display') === 'block' ||
        this.formElement.hasClass('is-visible');
    }
});
