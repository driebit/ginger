(function() {
    'use strict';

    function fetchJsonLd(url, callback, element) {
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.onload = function(e) {
            callback(element, e.target.response);
        };
        xmlHttp.open('GET', url, true);
        xmlHttp.setRequestHeader('Accept', 'application/ld+json');
        xmlHttp.send(null);
    }

    function formatDate(date) {
        // TODO Don't hardcode nl but base this on user's locale
        return date.toLocaleString('nl', {day: 'numeric', month: 'short', year: 'numeric'});
    }

    function getLinkElement(element) {
        return element.getElementsByTagName('a')[0];
    }

    function loadJsonLd(element, data) {
        var embedSize = element.getAttribute('embed-size') ? element.getAttribute('embed-size') : 'small';

        var json = JSON.parse(data),
            html =
                '<a href="'+getLinkElement(element).getAttribute('href')+'" class="ginger-embed embed-size-'+embedSize+'" target="_blank">';

        if (json['http://purl.org/dc/terms/publisher']) {
            html +=
            '    <div class="ginger-embed__origin">' +
            '       <h2 class="ginger-embed__origin-title">bron: '+json['http://purl.org/dc/terms/publisher']['@id']+'</h2>' +
            '    </div> ' +
            '    <div class="ginger-embed__origin-hover">' +
            '       <h2 class="ginger-embed__origin-title">ga naar '+json['http://purl.org/dc/terms/publisher']['@id']+'</h2>' +
            '    </div> ';
        }

        if (json['http://xmlns.com/foaf/0.1/thumbnail']) {
            html +=
                '    <picture>' +
                '        <img src="' + json['http://xmlns.com/foaf/0.1/thumbnail']['@id'] + '">' +
                '    </picture>';
        }

        html +=
            '    <div class="ginger-embed__header"> ' +
            '       <h1 class="ginger-embed__title">' + json['http://purl.org/dc/terms/title']  + '</h1>';
        if (json['http://purl.org/dc/terms/alternative']) {
            html += '<h2 class="ginger-embed__subtitle">' + json['http://purl.org/dc/terms/alternative'] + '</h2>';
        }
        html += '<time class="published ginger-embed__time" datetime="' + json['http://purl.org/dc/terms/issued'] + '">' + formatDate(new Date(json['http://purl.org/dc/terms/issued']), "YYYY") + '</time>' +
            '    </div> ' +
            '        <summary>' + json['http://purl.org/dc/terms/abstract'] + '</summary>' +
            '        <p class="ginger-embed__description">' + json['http://purl.org/dc/terms/description'].replace(/\n/, '<br>') + '</p>' +
            '        <button type="button" class="ginger-embed__button">&raquo;</button> ' +
            '</a>';

        element.innerHTML = html;
    }

    document.addEventListener('DOMContentLoaded', function() {
        Array.from(document.getElementsByTagName('ginger-embed')).forEach(function (element) {
            var url = getLinkElement(element).getAttribute('data-rdf');
            fetchJsonLd(url, loadJsonLd, element);
        });
    });
})();
