{% lib
    "css/edit-copyrights.css"
%}

<ul id="thing-cc" class="edit-copyrights">
    <li>
        <label for="rights-by">
            <input type="radio" name="rights" id="rights-by" value="BY" {% if r.rights|upper=="BY" %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc-by"></i>
            </div>
            <span class="caption">
                {_ You must give the original author credit _}
                {# Nl:  De gebruiker dient de naam of andere aanduiding van de maker te vermelden #}
            </span>
        </label>
    </li>
    <li>
        <label for="rights-by-nd">
            <input type="radio" name="rights" id="rights-by-nd" value="BY,ND" {% if r.rights|upper=="BY,ND" %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc-by"></i><i class="icon--cc-nd"></i>
            </div>
            <span class="caption">
                {_ You must give the original author credit, you may not alter, transform, or build upon this work. _}

                {# NL: De gebruiker dient de naam of andere aanduiding van de maker te vermelden, de gebruiker mag het werk niet bewerken. #}
            </span>
        </label>
    </li>
    <li>
        <label for="rights-by-nc">
            <input type="radio" name="rights" id="rights-by-nc" value="BY,NC" {% if r.rights|upper=="BY,NC" %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc-by"></i><i class="icon--cc-nc"></i>
            </div>
            <span class="caption">
                {_ You must give the original author credit, you may not use this work for commercial purposes _}
                {# NL: De gebruiker dient de naam of andere aanduiding van de maker te vermelden, de gebruiker mag het werk niet voor commerciële doeleinden gebruiken #}
            </span>
        </label>
   </li>
   <li>
        <label for="rights-by-nc-nd">
            <input type="radio" name="rights" id="rights-by-nc-nd" value="BY,NC,ND" {% if r.rights|upper=="BY,NC,ND" %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc-by"></i><i class="icon--cc-nc"></i><i class="icon--cc-nd"></i>
            </div>
            <span class="caption">
                {_ You must give the original author credit, you may not use this work for commercial purposes, you may not alter, transform, or build upon this work _}
                {# NL:  De gebruiker dient de naam of andere aanduiding van de maker te vermelden, de gebruiker mag het werk niet voor commerciële doeleinden gebruiken, de gebruiker mag het werk niet bewerken #}
            </span>
        </label>
    </li>
     <li>
        <label for="rights-by-sa">
            <input type="radio" name="rights" id="rights-by-sa" value="BY,SA" {% if r.rights|upper=="BY,SA" %}checked{% endif %} />
                {# {% if r.rights|upper=="BY,SA" %}checked{% endif %} #}
                <div class="edit-copyrights__icons">
                    <i class="icon--cc-by"></i><i class="icon--cc-sa"></i>
                </div>
                <span class="caption">
                    {_ You must give the original author credit, this work must be licensed under an identical license if used _}

                    {# NL: De gebruiker dient de naam of andere aanduiding van de maker te vermelden, indien de gebruiker het werk bewerkt kan het daaruit ontstane werk uitsluitend krachtens dezelfde licentie als de onderhavige licentie worden verspreid. #}
                </span>
        </label>
    </li>
    <li>
        <label for="rights-by-nc-sa">
            <input type="radio" name="rights" id="rights-by-nc-sa" value="BY,NC,SA" {% if r.rights|upper=="BY,NC,SA" %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc-by"></i><i class="icon--cc-nc"></i><i class="icon--cc-sa"></i>
            </div>
            <span class="caption">
                {_ You must give the original author credit, you may not use this work for commercial purposes, this work must be licensed under an identical license if used _}
                {# NL: De gebruiker dient de naam of andere aanduiding van de maker te vermelden, de gebruiker mag het werk niet voor commerciële doeleinden gebruiken, indien de gebruiker het werk bewerkt kan het daaruit ontstane werk uitsluitend krachtens dezelfde licentie als de onderhavige licentie worden verspreid. #}
            </span>
        </label>
   </li>
    <li>
        <label for="rights-pd">
            <input type="radio" name="rights" id="rights-pd" value="PD" {% if r.rights|upper=="PD" %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc-pd"></i>
            </div>
            <span class="caption">
                {_ You may use the work freely _}
                {# NL: Het werk mag vrijblijvend gebruikt worden #}
            </span>
        </label>
    </li>
    <li>
        <label for="rights-pd2">
            <input type="radio" name="rights" id="rights-pd2" value="CR" {% if r.rights %} {% else %}checked{% endif %} />
            <div class="edit-copyrights__icons">
                <i class="icon--cc"></i>
            </div>
            <span class="caption">
                {_ All rights reserved _}
                {# NL: De gebruiker moet toestemming vragen om gebruik te maken van de bijdrage. #}
            </span>
        </label>
   </li>
</ul>
