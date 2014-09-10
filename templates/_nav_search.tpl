<form class="navbar-form navbar-right hidden-sm" role="search" action="{% url search %}" method="get">
	<div class="form-group">
		<input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
		<input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
		<input type="text" class="form-control" name="qs" value="{{q.qs|escape}}" placeholder="Search">
	</div>
	<button type="submit" class="btn btn-default">Submit</button>
</form>
