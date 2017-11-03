
class GingerEmbed extends HTMLElement {
    constructor() {
        super();

        const shadow = this.attachShadow({
            mode: "closed"
        });

        this.properties = {
            url : "http://geheugenvanwest.docker.dev/rdf/26560"
        }
    }

    connectedCallback() {
        this._fetch().then(data => {
            console.log(data)
        })
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
