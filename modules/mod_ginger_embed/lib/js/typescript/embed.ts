interface Properties {
    url: string;
    theme: string;
    embedSize: Size;
}

enum Size {
    Large,
    Small
}

export default class GingerEmbedTs extends HTMLElement {
    shadow: ShadowRoot;
    properties: Properties;

    constructor() {
        super();

        this.shadow = this.attachShadow({
            mode: "closed"
        });

        this.properties = {
            url : "http://geheugenvanwest.docker.dev/rdf/26471",
            theme : "red",
            embedSize : Size.Large
        }
    }

    connectedCallback() {
        this._fetch(this.properties.url, this.render);
    }

    render(data : Object) {
        this.shadow.innerHTML =
            `${this.styles(this.properties)} ${this.template(data)}`;
    }

    template(data : Object) {
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

    styles({ theme } : Properties ) {
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

    _formatDate(date : string) {
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

    _fetch(url : Properties["url"], callback : Function) {
        const xhr = new XMLHttpRequest();

        xhr.open("GET", url);
        xhr.setRequestHeader('Accept', 'application/ld+json');
        xhr.onload = () => callback(JSON.parse(xhr.responseText));
        xhr.onerror = () => console.error(xhr.statusText);
        xhr.send();
    }
}

customElements.define("ginger-embed", GingerEmbedTs);
