import h from "hyperscript";
import styles from "embed";
import normalize from "normalize.css";

class GingerEmbed extends HTMLElement {
    constructor() {
        super();

        this.shadow = this.attachShadow({
            mode: "open"
        });

        this.properties = {
            url : "http://geheugenvanwest.docker.dev/rdf/26560",
            data : {},
            theme : "red",
            embedSize : "small"
        }
    }

    connectedCallback() {
        this.shadow.append(createStyles());

        this._fetch()
            .then(data => this.createTemplate(data))
            .catch(error => console.error(error));
    }

    createStyles() {
        const normalizeStyles = normalize.toString();
        const componentStyles = styles.toString();

        return h("style", (normalizeStyles + componentStyles))
    }

    createTemplate(data) {
        const anchorEl = h(`a.ginger-embed.embed-size-${this.properties.embedSize}`, {href: "/", target: "_blank"});

        if (data['http://purl.org/dc/terms/publisher']) {
            anchorEl.appendChild(this._createPublisher(data['http://purl.org/dc/terms/publisher']["@id"]));
        }

        if (data['http://xmlns.com/foaf/0.1/thumbnail']) {
            anchorEl.appendChild(this._createThumbnail(data['http://xmlns.com/foaf/0.1/thumbnail']['@id']));
        }

        anchorEl.appendChild(this._createHeader(data));
        anchorEl.appendChild(this._createContent(data));

        this.shadow.appendChild(anchorEl);
    }

    _createPublisher(title) {
        return h("aside",
            h("div.ginger-embed__origin",
                h("h2.ginger-embed__origin-title", [title, h("span", "»")])),
            h("div.ginger-embed__hover",
                h("h2.ginger-embed__origin-title", [title, h("span", "»")])));
    }

    _createThumbnail(url) {
        return h("img", {src: url})
    }

    _createContent(data) {
        return h("section",
            h("p.ginger-embed__summary", data['http://purl.org/dc/terms/abstract']),
            h("p.ginger-embed__description", data['http://purl.org/dc/terms/description'].replace(/\n/, '<br>')));
    }

    _createHeader(data) {
        const headerEl = h("div.ginger-embed__header",
            h("h1.ginger-embed__title", data['http://purl.org/dc/terms/title']));

        if (data['http://purl.org/dc/terms/alternative']) {
            const subtitleEl = h("h2.ginger-embed__subtitle", data['http://purl.org/dc/terms/alternative'])

            headerEl.appendChild(subtitleEl);
        }

        const metaEl = h("time.published.ginger-embed__time", {datetime : data['http://purl.org/dc/terms/issued']},
            this._formatDate(data['http://purl.org/dc/terms/issued'], "YYYY"));

        headerEl.appendChild(metaEl);

        return headerEl;
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
        return navigator.languages != undefined ?
            navigator.languages[0] :
            navigator.language;
    }

    _fetch() {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", this.properties.url);
            xhr.setRequestHeader('Accept', 'application/ld+json');
            xhr.onload = () => resolve(JSON.parse(xhr.responseText));
            xhr.onerror = () => reject(xhr.statusText);
            xhr.send();
        });
    }
}

// Define the new element
customElements.define("ginger-embed", GingerEmbed);

