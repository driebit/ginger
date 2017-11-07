"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
exports.__esModule = true;
var Size;
(function (Size) {
    Size[Size["Large"] = 0] = "Large";
    Size[Size["Small"] = 1] = "Small";
})(Size || (Size = {}));
var GingerEmbedTs = /** @class */ (function (_super) {
    __extends(GingerEmbedTs, _super);
    function GingerEmbedTs() {
        var _this = _super.call(this) || this;
        _this.shadow = _this.attachShadow({
            mode: "closed"
        });
        _this.properties = {
            url: "http://geheugenvanwest.docker.dev/rdf/26471",
            theme: "red",
            embedSize: Size.Large
        };
        return _this;
    }
    GingerEmbedTs.prototype.connectedCallback = function () {
        this._fetch(this.properties.url, this.render);
    };
    GingerEmbedTs.prototype.render = function (data) {
        this.shadow.innerHTML =
            this.styles(this.properties) + " " + this.template(data);
    };
    GingerEmbedTs.prototype.template = function (data) {
        var content = {
            publisher: data["http://purl.org/dc/terms/publisher"] ?
                data["http://purl.org/dc/terms/publisher"]["@id"] + " \u00BB" : "",
            thumb: data['http://xmlns.com/foaf/0.1/thumbnail'] ?
                data['http://xmlns.com/foaf/0.1/thumbnail']['@id'] : "",
            abstract: data['http://purl.org/dc/terms/abstract'],
            description: data['http://purl.org/dc/terms/description']
                .split(" ").slice(0, 100).join(" ") + "...",
            date: this._formatDate(data['http://purl.org/dc/terms/issued']),
            title: data['http://purl.org/dc/terms/title'],
            subtitle: data['http://purl.org/dc/terms/alternative'] || ""
        };
        var template = "<main>\n                <h4>" + content.publisher + "</h4>\n                <header>\n                    <img src=" + content.thumb + ">\n                    <div>\n                        <h1>" + content.title + "</h1>\n                        <h2>" + content.subtitle + "</h1>\n                    </div>\n                </header>\n                <section>\n                    <h3>" + content.abstract + "</h3>\n                    <p>" + content.description + "</p>\n                </section>\n            </main>";
        return template;
    };
    GingerEmbedTs.prototype.styles = function (_a) {
        var theme = _a.theme;
        var styles = "<style>\n                :host {\n                    display: block;\n                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;\n                    line-height: 160%;\n                    border: 1px solid " + theme + ";\n                }\n\n                main {\n                    padding: 2rem;\n                }\n\n                h1, h2, h3, h4 {\n                    margin: 0;\n                    padding: 0;\n                    line-height: 130%;\n                }\n\n                h1 {\n                    font-size: 3rem;\n                    font-weight: 500;\n                }\n\n                h2 {\n                    font-size: 2rem;\n                    font-weight: 500;\n                }\n\n                h3 {\n                    font-size: 1.5rem;\n                    font-weight: 400;\n                    text-transform: uppercase;\n                }\n\n                h4 {\n                    font-size: 1.5rem;\n                    font-weight: 500;\n                    text-transform: uppercase;\n                    background-color: " + theme + ";\n                    padding: 1rem;\n                }\n\n                header {\n                    display: flex;\n                    margin: 2rem 0;\n                }\n\n                img {\n                    width: 100px;\n                    height: auto;\n                    margin-right: 2rem;\n                }\n\n                p {\n                    margin: 1rem 0;\n                }\n            </style>\n            ";
        return styles;
    };
    GingerEmbedTs.prototype._formatDate = function (date) {
        var newDate = new Date(date);
        var locale = this._getlLocale();
        return newDate.toLocaleString(locale, {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        });
    };
    GingerEmbedTs.prototype._getlLocale = function () {
        return navigator.languages ?
            navigator.languages[0] :
            navigator.language;
    };
    GingerEmbedTs.prototype._fetch = function (url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.setRequestHeader('Accept', 'application/ld+json');
        xhr.onload = function () { return callback(JSON.parse(xhr.responseText)); };
        xhr.onerror = function () { return console.error(xhr.statusText); };
        xhr.send();
    };
    return GingerEmbedTs;
}(HTMLElement));
exports["default"] = GingerEmbedTs;
customElements.define("ginger-embed", GingerEmbedTs);
