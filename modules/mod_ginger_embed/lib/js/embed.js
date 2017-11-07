/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports) {

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _CustomElement() {
  return Reflect.construct(HTMLElement, [], this.__proto__.constructor);
}

;
Object.setPrototypeOf(_CustomElement.prototype, HTMLElement.prototype);
Object.setPrototypeOf(_CustomElement, HTMLElement);

(function () {
  window.WebComponents = window.WebComponents || {};
  window.addEventListener("WebComponentsReady", function () {
    initCustomElement();
  });

  function needsPolyfill() {
    return !('attachShadow' in Element.prototype && 'getRootNode' in Element.prototype) || window.ShadyDOM && window.ShadyDOM.force || !window.customElements || window.customElements.forcePolyfill;
  }

  if (needsPolyfill()) {
    var script = document.createElement("script");
    var embed = document.getElementsByTagName("ginger-embed")[0];
    var baseurl = embed ? embed.getAttribute("src") : "";
    script.src = "".concat(baseurl, "/polyfill/webcomponents-sd-ce.js");
    document.head.appendChild(script);
  }

  if (document.readystate !== 'loading') {
    fireready();
    initCustomElement();
  } else {
    initCustomElement();
    document.addEventlistener('readystatechange', function wait() {
      fireready();
      document.removeEventlistener('readystatechange', wait);
    });
  }

  function fireready() {
    requestAnimationFrame(function () {
      window.WebComponents.ready = true;
      document.dispatchEvent(new CustomEvent('webcomponentsready', {
        bubbles: true
      }));
    });
  }

  ;

  function initCustomElement() {
    var GingerEmbed =
    /*#__PURE__*/
    function (_CustomElement2) {
      _inherits(GingerEmbed, _CustomElement2);

      function GingerEmbed() {
        var _this;

        _classCallCheck(this, GingerEmbed);

        _this = _possibleConstructorReturn(this, (GingerEmbed.__proto__ || Object.getPrototypeOf(GingerEmbed)).call(this));
        _this.shadow = _this.attachShadow({
          mode: "closed"
        }); // console.log(this.attributes);

        _this.properties = {
          url: "http://geheugenvanwest.docker.dev/rdf/26471",
          data: {},
          theme: "red",
          embedSize: "small"
        };
        return _this;
      }

      _createClass(GingerEmbed, [{
        key: "connectedCallback",
        value: function connectedCallback() {
          this._fetch(this.properties.url);
        }
      }, {
        key: "render",
        value: function render(data) {
          var iframe = document.createElement("template");

          if (needsPolyfill()) {
            ShadyCSS.prepareTemplate(template, 'ginger-embed');
          }

          var templateClone = document.importNode(template.content, true);
          templateClone.appendChild(this.styles(this.properties));
          templateClone.appendChild(this.template(data)); // A template element must be 'activated' in order to be used
          // https://www.html5rocks.com/en/tutorials/webcomponents/template/

          this.shadow.appendChild(templateClone); // ShadyCSS.styleElement(style);
        }
      }, {
        key: "template",
        value: function template(data) {
          var content = {
            publisher: data["http://purl.org/dc/terms/publisher"] ? "".concat(data["http://purl.org/dc/terms/publisher"]["@id"], " \xBB") : "",
            thumb: data['http://xmlns.com/foaf/0.1/thumbnail'] ? data['http://xmlns.com/foaf/0.1/thumbnail']['@id'] : "",
            abstract: data['http://purl.org/dc/terms/abstract'],
            description: "".concat(data['http://purl.org/dc/terms/description'].split(" ").slice(0, 100).join(" "), "..."),
            date: this._formatDate(data['http://purl.org/dc/terms/issued']),
            title: data['http://purl.org/dc/terms/title'],
            subtitle: data['http://purl.org/dc/terms/alternative'] || ""
          };
          var main = "<main>\n                        <h4>".concat(content.publisher, "</h4>\n                        <header>\n                            <img src=").concat(content.thumb, ">\n                            <div>\n                                <h1>").concat(content.title, "</h1>\n                                <h2>").concat(content.subtitle, "</h1>\n                            </div>\n                        </header>\n                        <section>\n                            <h3>").concat(content.abstract, "</h3>\n                            <p>").concat(content.description, "</p>\n                        </section>\n                    </main>");
          var mainElement = document.createElement("main");
          mainElement.innerHTML = main;
          return mainElement;
        }
      }, {
        key: "styles",
        value: function styles(_ref) {
          var theme = _ref.theme;
          var styles = "   :host {\n                            display: block;\n                            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;\n                            line-height: 160%;\n                            border: 1px solid ".concat(theme, ";\n                        }\n\n                        main {\n                            padding: 2rem;\n                        }\n\n                        h1, h2, h3, h4 {\n                            margin: 0;\n                            padding: 0;\n                            line-height: 130%;\n                        }\n\n                        h1 {\n                            font-size: 3rem;\n                            font-weight: 500;\n                        }\n\n                        h2 {\n                            font-size: 2rem;\n                            font-weight: 500;\n                        }\n\n                        h3 {\n                            font-size: 1.5rem;\n                            font-weight: 400;\n                            text-transform: uppercase;\n                        }\n\n                        h4 {\n                            font-size: 1.5rem;\n                            font-weight: 500;\n                            text-transform: uppercase;\n                            background-color: ").concat(theme, ";\n                            padding: 1rem;\n                        }\n\n                        header {\n                            display: flex;\n                            margin: 2rem 0;\n                        }\n\n                        img {\n                            width: 100px;\n                            height: auto;\n                            margin-right: 2rem;\n                        }\n\n                        p {\n                            margin: 1rem 0;\n                        }");
          var styleElement = document.createElement("style");
          styleElement.innerText = styles;
          return styleElement;
        }
      }, {
        key: "_formatDate",
        value: function _formatDate(date) {
          var newDate = new Date(date);

          var locale = this._getlLocale();

          return newDate.toLocaleString(locale, {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
          });
        }
      }, {
        key: "_getlLocale",
        value: function _getlLocale() {
          return navigator.languages ? navigator.languages[0] : navigator.language;
        }
      }, {
        key: "_fetch",
        value: function _fetch(url) {
          var _this2 = this;

          var xhr = new XMLHttpRequest();
          xhr.open("GET", url);
          xhr.setRequestHeader('Accept', 'application/ld+json');

          xhr.onload = function () {
            return _this2.render(JSON.parse(xhr.responseText));
          };

          xhr.onerror = function () {
            return console.error(xhr.statusText);
          };

          xhr.send();
        }
      }]);

      return GingerEmbed;
    }(_CustomElement);

    customElements.define("ginger-embed", GingerEmbed);
  }
})();

/***/ })
/******/ ]);