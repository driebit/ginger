
<div class="remarks do_remarks_widget">


    <div class="buttons">
        <a href="#" id="" class="new">new</a>
    </div>


    <!-- <div class="aapnew" id="aapnew">HIER IN</div> -->

    <div id="testrefresh">
        {% include "remark/remark.tpl" id=1 %}
    </div>


</div>

{#% wire name="aapnew"
    action={insert_top target="aapnew" template="remark/remark.tpl"}
%#}

{% wire name="testrefresh" action={update target="testrefresh" template="remark/remark.tpl"} %}

{% wire id="rscform" type="submit" postback={rscform view_location=view_location} delegate=`controller_admin_edit` %}
