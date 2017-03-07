<div class="search__filters__section--license is-open {#do_search_cmp_filters_rights #}">
    <h3 class="search__filters__title">{_ CC license _}</h3>

    <ul>
    	<li>
    		<input type="radio" name="rights" id="rights-cc0" value="CC0" {% if rights|upper=="CC0" %}checked{% endif %} /><label for="rights-cc0" title="CC0: {_ No rights reserved _}"><i class="icon-cc icon--cc-cc0"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-pd" value="PD" {% if rights|upper=="PD" %}checked{% endif %} /><label for="rights-pd" title="{_ Public Domain _}"><i class="icon-cc icon--cc-pd"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-by" value="BY" {% if rights|upper=="BY" %}checked{% endif %} /><label for="rights-by" title="BY: {_ Attribution _}"><i class="icon-cc icon--cc-by"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-by-sa" value="BY,SA" {% if rights|upper=="BY,SA" %}checked{% endif %} /><label for="rights-by-sa" title="BY-SA: {_ Attribution-ShareAlike _}"><i class="icon-cc icon--cc-by"></i> <i class="icon-cc icon--cc-sa"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-by-nd" value="BY,ND" {% if rights|upper=="BY,ND" %}checked{% endif %} /><label for="rights-by-nd" title="BY-ND: {_ Attribution-NoDerivs _}"><i class="icon-cc icon--cc-by"></i> <i class="icon-cc icon--cc-nd"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-by-nc" value="BY,NC" {% if rights|upper=="BY,NC" %}checked{% endif %} /><label for="rights-by-nc" title="BY-NC: {_ Attribution-NonCommercial _}"><i class="icon-cc icon--cc-by"></i> <i class="icon--cc-nc"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-by-nc-sa" value="BY,NC,SA" {% if rights|upper=="BY,NC,SA" %}checked{% endif %} /><label for="rights-by-nc-sa" title="BY-NC-SA: {_ Attribution-NonCommercial-ShareAlike _}"><i class="icon-cc icon--cc-by"></i> <i class="icon--cc-nc"></i> <i class="icon--cc-sa"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-by-nc-nd" value="BY,NC,ND" {% if rights|upper=="BY,NC,ND" %}checked{% endif %} /><label for="rights-by-nc-nd" title="BY-NC-ND: {_ Attribution-NonCommercial-NoDerivs _}"><i class="icon-cc icon--cc-by"></i> <i class="icon--cc-nc"></i> <i class="icon--cc-nd"></i></label>
		</li>
		<li>
			<input type="radio" name="rights" id="rights-pd2" value="CR" {% if rights|upper == "CR" or rights|is_undefined %}checked{% endif %} /><label for="rights-pd2">{_ All rights reserved _}</label>
		</li>
    </ul>
</div>