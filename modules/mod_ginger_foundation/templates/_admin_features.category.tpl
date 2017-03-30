<div class="col-md-12">
    <div class="checkbox">
        <label>
            <input value="true" type="checkbox"
                name="feature_enable_comments"
                {% if id.feature_enable_comments|if_undefined:`true` %}checked{% endif %}
            />
            {_ Enable comments _}
        </label>
    </div>
</div>
