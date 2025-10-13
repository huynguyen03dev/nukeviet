/**
 * Dictionary Module - Admin JavaScript
 * NukeViet CMS
 */

(function($) {
  'use strict';
  
  var DictionaryModule = {
    /**
     * Initialize examples manager for entry form
     */
    initExamplesManager: function() {
      var btn = document.getElementById('btn-add-example');
      var container = document.getElementById('examples-container');
      if (!btn || !container) return;

      /**
       * Update example numbers after add/remove
       */
      function updateExampleNumbers() {
        var items = container.querySelectorAll('.example-item');
        var langExample = document.body.dataset.langExample || 'Example';
        items.forEach(function(item, index) {
          var numberSpan = item.querySelector('.example-number');
          if (numberSpan) {
            numberSpan.textContent = langExample + ' ' + (index + 1);
          }
        });
      }

      /**
       * Add a new example input block
       */
      function addExample() {
        var item = document.createElement('div');
        item.className = 'example-item example-item-enter';
        
        var currentCount = container.querySelectorAll('.example-item').length;
        
        // Get language strings from data attributes or use defaults
        var langExample = document.body.dataset.langExample || 'Example';
        var langRemove = document.body.dataset.langRemoveExample || 'Remove example';
        var langSentence = document.body.dataset.langExampleSentence || 'Sentence (EN)';
        var langTranslation = document.body.dataset.langExampleTranslation || 'Translation (VI)';
        var langSentencePlaceholder = document.body.dataset.langExampleSentencePlaceholder || 'Example sentence in English';
        var langTranslationPlaceholder = document.body.dataset.langExampleTranslationPlaceholder || 'Vietnamese translation (optional)';
        
        item.innerHTML = '<div class="example-header">' +
            '<span class="example-number">' + langExample + ' ' + (currentCount + 1) + '</span>' +
            '<button type="button" class="example-remove-btn" data-remove-example aria-label="' + langRemove + '" title="' + langRemove + '">&times;</button>' +
          '</div>' +
          '<div class="example-row">' +
            '<label>' + langSentence + '</label>' +
            '<input type="text" name="ex_sentence_en[]" placeholder="' + langSentencePlaceholder + '">' +
          '</div>' +
          '<div class="example-row">' +
            '<label>' + langTranslation + '</label>' +
            '<input type="text" name="ex_translation_vi[]" placeholder="' + langTranslationPlaceholder + '">' +
          '</div>';
        
        container.appendChild(item);
        
        // Focus on the first input
        setTimeout(function() {
          var firstInput = item.querySelector('input[name="ex_sentence_en[]"]');
          if (firstInput) firstInput.focus();
        }, 100);
      }

      // Add example button click handler
      btn.addEventListener('click', addExample);

      // Remove example button click handler
      container.addEventListener('click', function(e){
        var target = e.target;
        if (!target || target.getAttribute('data-remove-example') === null) {
          return;
        }
        var item = target.closest('.example-item');
        if (item && item.parentNode === container) {
          // Add fade out animation
          item.style.opacity = '0';
          item.style.transform = 'translateX(20px)';
          setTimeout(function() {
            container.removeChild(item);
            updateExampleNumbers();
          }, 200);
        }
      });

      // Add initial example on page load for better UX (optional)
      // Uncomment the line below if you want one example field to show by default
      // addExample();
    },

    /**
     * Initialize the module
     */
    init: function() {
      this.initExamplesManager();
    }
  };
  
  // Initialize on document ready
  $(document).ready(function() {
    DictionaryModule.init();
  });

})(jQuery);

