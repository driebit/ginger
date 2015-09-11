{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}{% endblock %}

{% block content %}

    <h1>all in</h1>

   {% include "all-in/all-in.tpl" %}

{% endblock %}