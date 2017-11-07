import GingerEmbed from "./embed";

(<any>window).WebComponents = (<any>window).WebComponents || {};

window.addEventListener("WebComponentsReady", () => {
    // Define the new element
    // console.log(GingerEmbed)
    (<any>window).customElements.define("ginger-embed", GingerEmbed);
})

// Check custom element and shadow dom support and polyfill if neccesary.
if (!('attachShadow' in Element.prototype && 'getRootNode' in Element.prototype) ||
    ((<any>window).ShadyDOM && (<any>window).ShadyDOM.force) ||
    !window.customElements ||
    (<any>window).customElements.forcePolyfill) {
    const script = document.createElement("script");
    const embed = document.getElementsByTagName("ginger-embed")[0];
    const baseUrl = embed ? embed.getAttribute("src") : "";
    script.src = `${baseUrl}/polyfill/webcomponents-sd-ce.js`;

    document.head.appendChild(script);
}

// if (document.readyState !== 'loading') {
//     fireReady();
// } else {
//     document.addEventListener('readystatechange', function wait() {
//         fireReady();
//         document.removeEventListener('readystatechange', wait);
//     });
// }

// function fireReady() {
//     requestAnimationFrame(() => {
//         window.WebComponents.ready = true;
//         document.dispatchEvent(new CustomEvent('WebComponentsReady', {
//             bubbles: true
//         }));
//     });
// };
