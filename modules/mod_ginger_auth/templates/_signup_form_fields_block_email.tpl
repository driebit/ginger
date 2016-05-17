<div class="form-group" id="hide_email">
    <div class="checkbox" id="block_email_group">
        <label for="block_email">
            <input type="checkbox" name="block_email" id="block_email" value="1" />
            {_ I do not want to receive emails from other users or the editorial office _}. {% if m.rsc.block_email_about %}<a href="{{ m.rsc.block_email_about.page_url }}" target="_blank" title="{_ Need more help? _}" class="z-btn-help"></a>{% endif %}
        </label>
    </div>
</div>
