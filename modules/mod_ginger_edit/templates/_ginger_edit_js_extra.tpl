<script>

var has_connection = function (value, args, isSubmit, submitTrigger) {
    
    var element = $('#' + args);
        items = element.find('ul:eq(0) li'),
        isValid = items.size() > 0 ? true : false;

        element.removeClass('has-error');

        if(!isValid) {
            element.addClass('has-error');
        }

        return isValid;
}

</script>