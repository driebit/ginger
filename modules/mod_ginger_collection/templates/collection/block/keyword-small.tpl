<h4>{{ rdf.title }}</h4>

<p>{{ rdf.abstract }}</p>

<img src="{{ rdf.thumbnail }}">


<a href="{{ rdf['http://xmlns.com/foaf/0.1/isPrimaryTopicOf'] }}">{_ Read more _}</a>
