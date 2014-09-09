<nav class="navbar navbar-default" role="navigation">
	<div class="container-fluid">
		
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/">{{ m.config.site.title.value }}</a>
		</div>

		<div class="collapse navbar-collapse" id="navbar-collapse">
			{% menu menu_id=menu_id id=id %}
			{% include "_language.tpl" %}
			{% include "_search.tpl" %}
		</div>
	</div>
</nav>