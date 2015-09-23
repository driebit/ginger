{% with last_year|default:now|date:"Y" as last_year %}
<div id="signup_date_of_birth"class="form-group">
   <label for="date_of_birth" class="control-label">{_ Date of birth _}</label>
   <div class="controls">
      <select name="dob_year" id="dob_year">
      {% with (last_year-100)|range:last_year|reversed as Years %}
        {% for y in Years %}
            <option value="{{ y }}">{{ y }}</option>
        {% endfor %}
      {% endwith %}
      </select>
      <select name="dob_month" id="dob_month">
      {% with 1|range:12 as Months %}
        {% for m in Months %}
            <option value="{{ m }}">{{ m }}</option>
        {% endfor %}
      {% endwith %}
      </select>
      <select name="dob_day" id="dob_day">
      {% with 1|range:31 as Days %}
        {% for d in Days %}
            <option value="{{ d }}">{{ d }}</option>
        {% endfor %}
      {% endwith %}
      </select>
   </div>
</div>
{% endwith %}
