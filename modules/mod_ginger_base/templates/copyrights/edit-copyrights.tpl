<p>{_ These are the <a href="https://creativecommons.org/licenses/">Creative Commons licenses</a>. _}</p>

<div class="radio">
    <label for="rights-cc0">
        <input type="radio" name="rights" id="rights-cc0" value="CC0" {% if rights|upper=="CC0" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc-cc0"></i>
        </div>
        <span class="caption">CC0: {_ No rights reserved _}</span>
    </label>
</div>
<div class="radio">
    <label for="rights-pd" class="radio-inline">
        <input type="radio" name="rights" id="rights-pd" value="PD" {% if rights|upper=="PD" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc-pd"></i>
        </div>
        <span class="caption">{_ Public Domain _}</span>
    </label>
</div>
<div class="radio">
    <label for="rights-by" class="radio-inline">
        <input type="radio" name="rights" id="rights-by" value="BY" {% if rights|upper=="BY" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc-by"></i>
        </div>
        <span class="caption">BY: {_ Attribution _}</span>
    </label>
</div>
<div class="radio">
    <label for="rights-by-sa" class="radio-inline">
        <input type="radio" name="rights" id="rights-by-sa" value="BY,SA" {% if rights|upper=="BY,SA" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc-by"></i> <i class="icon-cc icon--cc-sa"></i>
        </div>
        <span class="caption">BY-SA: {_ Attribution-ShareAlike _}</span>
    </label>
</div>
<div class="radio">
    <label for="rights-by-nd" class="radio-inline">
        <input type="radio" name="rights" id="rights-by-nd" value="BY,ND" {% if rights|upper=="BY,ND" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc-by"></i> <i class="icon-cc icon--cc-nd"></i>
        </div>
        <span class="caption">BY-ND: {_ Attribution-NoDerivs _}</span>
    </label>
</div>
<div class="radio">
     <label for="rights-by-nc" class="radio-inline">
         <input type="radio" name="rights" id="rights-by-nc" value="BY,NC" {% if rights|upper=="BY,NC" %}checked{% endif %} />
         <div class="edit-copyrights__icons">
             <i class="icon-cc icon--cc-by"></i> <i class="icon--cc-nc"></i>
         </div>
         <span class="caption">BY-NC: {_ Attribution-NonCommercial _}</span>
     </label>
</div>
<div class="radio">
     <label for="rights-by-nc-sa" class="radio-inline">
         <input type="radio" name="rights" id="rights-by-nc-sa" value="BY,NC,SA" {% if rights|upper=="BY,NC,SA" %}checked{% endif %} />
         <div class="edit-copyrights__icons">
             <i class="icon-cc icon--cc-by"></i> <i class="icon--cc-nc"></i> <i class="icon--cc-sa"></i>
         </div>
         <span class="caption">BY-NC-SA: {_ Attribution-NonCommercial-ShareAlike _}</span>
     </label>
</div>
<div class="radio">
    <label for="rights-by-nc-nd" class="radio-inline">
        <input type="radio" name="rights" id="rights-by-nc-nd" value="BY,NC,ND" {% if rights|upper=="BY,NC,ND" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc-by"></i> <i class="icon--cc-nc"></i> <i class="icon--cc-nd"></i>
        </div>
        <span class="caption">BY-NC-ND: {_ Attribution-NonCommercial-NoDerivs _}</span>
    </label>
</div>
<div class="radio">
    <label for="rights-pd2" class="radio-inline">
        <input type="radio" name="rights" id="rights-pd2" value="CR" {% if rights|upper == "CR" %}checked{% endif %} />
        <div class="edit-copyrights__icons">
            <i class="icon-cc icon--cc"></i>
        </div>
        <span class="caption">{_ All rights reserved _}</span>
    </label>
</div>

