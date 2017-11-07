(function () {
    window.WebComponents = window.WebComponents || {};

    window.addEventListener("WebComponentsReady", () => {
        initCustomElement();
    });

    function needsPolyfill() {
        return !('attachShadow' in Element.prototype && 'getRootNode' in Element.prototype) ||
        (window.ShadyDOM && window.ShadyDOM.force) ||
        !window.customElements ||
        window.customElements.forcePolyfill;
    }

    if (needsPolyfill()) {
        const script = document.createElement("script");
        const embed = document.getElementsByTagName("ginger-embed")[0];
        const baseurl = embed ? embed.getAttribute("src") : "";
        script.src = `${baseurl}/polyfill/webcomponents-sd-ce.js`;

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
        requestAnimationFrame(() => {
            window.WebComponents.ready = true;
            document.dispatchEvent(new CustomEvent('webcomponentsready', {
                bubbles: true
            }));
        });
    };

    function initCustomElement() {


        class GingerEmbed extends HTMLElement {
            constructor() {
                super();

                this.shadow = this.attachShadow({
                    mode: "closed"
                });

                // console.log(this.attributes);

                this.properties = {
                    url: "http://geheugenvanwest.docker.dev/rdf/26471",
                    data: {},
                    theme: "red",
                    embedSize: "small"
                };
            }

            connectedCallback() {
                this._fetch(this.properties.url);
            }

            render(data) {
                let iframe = document.createElement("template");

                if (needsPolyfill()) {
                    ShadyCSS.prepareTemplate(template, 'ginger-embed');
                }

                const templateClone = document.importNode(template.content, true);
                templateClone.appendChild(this.styles(this.properties));
                templateClone.appendChild(this.template(data));

                // A template element must be 'activated' in order to be used
                // https://www.html5rocks.com/en/tutorials/webcomponents/template/

                this.shadow.appendChild(templateClone);

                // ShadyCSS.styleElement(style);

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
                };

                const main =
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
                    </main>`;

                const mainElement = document.createElement("main");
                mainElement.innerHTML = main;
                return mainElement;
            }

            styles({theme}) {
                const styles =
                    `   :host {
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
                        }`;

                const styleElement = document.createElement("style");
                styleElement.innerText = styles;

                return styleElement;
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

        customElements.define("ginger-embed", GingerEmbed);
    }
}());
