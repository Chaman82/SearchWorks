(function($) {

  /*
    jQuery plugin to attach preview triggers and render previews in
    brief view

      Usage: $(selector).previewBrief();

    This plugin :
      - adds preview triggers to the brief preview button
      - on preview click event, fetches preview content from
        'data-preview-url' data attribute value and renders it
  */


  $.fn.previewBrief = function() {

    return this.each(function() {
      var $item = $(this),
          $previewTarget = $($item.data('preview-target')),
          previewUrl = $item.data('preview-url'),
          $triggerBtn, $briefTarget;

      init();
      attachTriggerEvents();

      function showPreview() {
        $previewTarget.addClass('preview').empty();

        PreviewContent.append(previewUrl, $previewTarget);

        $triggerBtn
          .addClass('preview-open')
          .html('<span class="glyphicon glyphicon-chevron-up"></span> Close');

        $briefTarget.hide();

        $previewTarget.show();
      }


      function attachTriggerEvents() {
        $item.find($triggerBtn).on('click', function() {
          $(this).hasClass('preview-open') ? closePreview() : showPreview();
        });
      }

      function closePreview() {
        $previewTarget.removeClass('preview').hide();
        $briefTarget.show();

        $triggerBtn
          .removeClass('preview-open')
          .html('<span class="glyphicon glyphicon-chevron-right"></span> Preview');
      }

      function init() {
        $triggerBtn = $item.find('*[data-behavior="preview-button-trigger"]');
        $briefTarget = $item.find('.brief-container');
      }

    });

  };

})(jQuery);


Blacklight.onLoad(function() {
  $('*[data-behavior="preview-brief"]').previewBrief();
});