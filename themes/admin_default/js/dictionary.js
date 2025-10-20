/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

function nv_delete_entry(id) {
    if (confirm(nv_is_del_confirm[0])) {
        $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_op_variable + '=entry_list&nocache=' + new Date().getTime(), 'delete=1&id=' + id, function(res) {
            if (res == 'OK') {
                window.location.href = window.location.href;
            } else {
                alert(res);
            }
        });
    }
    return false;
}

$(function() {
    // Fix search input cursor position
    var searchInput = $('input[name="search"]');
    if (searchInput.length && searchInput.val()) {
        var val = searchInput.val();
        searchInput.focus().val('').val(val);
    }

    var btn = document.getElementById('btn-add-example');
    var container = document.getElementById('examples-container');

    if (btn && container) {
        // Update example numbers after add/remove
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

        // Add a new example input block
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
            var langExampleAudio = document.body.dataset.langExampleAudio || 'Example Audio';
            var langAudioOptional = document.body.dataset.langAudioOptional || 'Optional - MP3 or WAV, max 5MB';

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
              '</div>' +
              '<div class="example-row">' +
                '<label>' + langExampleAudio + '</label>' +
                '<input type="file" name="ex_audio[]" accept="audio/mp3,audio/mpeg,audio/wav">' +
                '<small class="help-text">' + langAudioOptional + '</small>' +
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
        container.addEventListener('click', function(e) {
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
    }
});

