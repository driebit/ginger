<script>

var has_list_content = function (element, selector) {
    var items = element.find(selector);
 
    return items.size() > 0 ? true : false;
}

var set_error_class = function (element, valid) {
    element.removeClass('has-error');

    if(valid == false) {
        element.addClass('has-error');
    }
}

var has_connection = function (value, args, isSubmit, submitTrigger) {
    
    var element = $('#' + args), 
        isValid = has_list_content(element, 'ul:eq(0) li');
    
    set_error_class(element, isValid);

    return isValid;
}

var has_date = function (value, args, isSubmit, submitTrigger) {
    var element = $('#' + args),
        isValid = element.val() ?  true : false;
    
    set_error_class(element, isValid);
    
    return isValid;
}

</script>