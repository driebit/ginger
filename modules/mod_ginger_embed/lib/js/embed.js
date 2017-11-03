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
/******/ 	return __webpack_require__(__webpack_require__.s = 1);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */,
/* 1 */
/***/ (function(module, exports) {


class GingerEmbed extends HTMLElement {
    constructor() {
        super();

        this.shadow = this.attachShadow({
            mode: "closed"
        });

        this.properties = {
            url : "http://geheugenvanwest.docker.dev/rdf/26471",
            data : {},
            theme : "red",
            embedSize : "small"
        }
    }

    connectedCallback() {
        this._fetch(this.properties.url);
    }

    render(data) {
        this.shadow.innerHTML =
            `${this.styles(this.properties)} ${this.template(data)}`;
    }

    template(data) {
        const content = {
            publisher: data["http://purl.org/dc/terms/publisher"] ?
                `${data["http://purl.org/dc/terms/publisher"]["@id"]} »` : "",
            thumb: data['http://xmlns.com/foaf/0.1/thumbnail'] ?
                data['http://xmlns.com/foaf/0.1/thumbnail']['@id'] : "",
            abstract: data['http://purl.org/dc/terms/abstract'],
            description: `${data['http://purl.org/dc/terms/description']
                .split(" ").slice(0,100).join(" ")}...`,
            date: this._formatDate(data['http://purl.org/dc/terms/issued']),
            title: data['http://purl.org/dc/terms/title'],
            subtitle: data['http://purl.org/dc/terms/alternative'] || ""
        }

        const template =
            `<main>
                <h4>${content.publisher}</h4>
                <header>
                    <img src=${content.thumb}>
                    <div>
                        <h1>${content.title}</h1>
                        <h2>${content.subtitle}</h1>
                    </div>
                </header>
                <section>
                    <h3>${content.abstract}</h3>
                    <p>${content.description}</p>
                </section>
            </main>`

        return template;
    }

    styles({ theme }) {
        const styles =
            `<style>
                :host {
                    display: block;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
                    line-height: 160%;
                    border: 1px solid ${theme};
                }

                main {
                    padding: 2rem;
                }

                h1, h2, h3, h4 {
                    margin: 0;
                    padding: 0;
                    line-height: 130%;
                }

                h1 {
                    font-size: 3rem;
                    font-weight: 500;
                }

                h2 {
                    font-size: 2rem;
                    font-weight: 500;
                }

                h3 {
                    font-size: 1.5rem;
                    font-weight: 400;
                    text-transform: uppercase;
                }

                h4 {
                    font-size: 1.5rem;
                    font-weight: 500;
                    text-transform: uppercase;
                    background-color: ${theme};
                    padding: 1rem;
                }

                header {
                    display: flex;
                    margin: 2rem 0;
                }

                img {
                    width: 100px;
                    height: auto;
                    margin-right: 2rem;
                }

                p {
                    margin: 1rem 0;
                }
            </style>
            `
        return styles;
    }

    _formatDate(date) {
        const newDate = new Date(date);
        const locale = this._getlLocale();

        return newDate.toLocaleString(locale, {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        });
    }

    _getlLocale() {
        return navigator.languages ?
            navigator.languages[0] :
            navigator.language;
    }

    _fetch(url) {
        const xhr = new XMLHttpRequest();

        xhr.open("GET", url);
        xhr.setRequestHeader('Accept', 'application/ld+json');
        xhr.onload = () => this.render(JSON.parse(xhr.responseText));
        xhr.onerror = () => console.error(xhr.statusText);
        xhr.send();
    }
}

// Define the new element
customElements.define("ginger-embed", GingerEmbed);



/***/ })
/******/ ]);