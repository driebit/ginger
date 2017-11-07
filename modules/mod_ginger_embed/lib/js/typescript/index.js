"use strict";
exports.__esModule = true;
var embed_1 = require("./embed");
window.WebComponents = window.WebComponents || {};
window.addEventListener("WebComponentsReady", function () {
    // Define the new element
    // console.log(GingerEmbed)
    window.customElements.define("ginger-embed", embed_1["default"]);
});
// Check custom element and shadow dom support and polyfill if neccesary.
if (!('attachShadow' in Element.prototype && 'getRootNode' in Element.prototype) ||
    (window.ShadyDOM && window.ShadyDOM.force) ||
    !window.customElements ||
    window.customElements.forcePolyfill) {
    var script = document.createElement("script");
    var embed = document.getElementsByTagName("ginger-embed")[0];
    var baseUrl = embed ? embed.getAttribute("src") : "";
    script.src = baseUrl + "/polyfill/webcomponents-sd-ce.js";
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
