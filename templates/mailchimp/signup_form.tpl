{% with
    url
as
    url
%}

    <form action="{{ url }}" method="post" target="_blank" novalidate>

        <div class="form-group">
            <label for="mailchimp-email">{{ _"E-mail address" }}</label>
            <input type="email" value="" name="EMAIL" class="form-control" id="mailchimp-email" placeholder="{{ _"E-mail address" }}">
        </div>

        <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
        <div style="position: absolute; left: -5000px;"><input type="text" name="b_c01d254db25c5769a53ed4dce_350987cd0c" tabindex="-1" value=""></div>

        <button type="submit" class="btn btn--primary pull-right">{{ _"mailchimp-sign-up" }}</button>

    </form>

{% endwith %}
