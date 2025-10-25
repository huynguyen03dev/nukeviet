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
        $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=entry_list&nocache=' + new Date().getTime(), 'delete=1&id=' + id, function(res) {
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
            var langUploadAudio = document.body.dataset.langUploadAudioBtn || 'Upload Audio';

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
                '<div class="audio-card audio-card-empty">' +
                  '<div class="audio-card-header">' +
                    '<span class="audio-card-icon"><i class="fa fa-music"></i></span>' +
                    '<div class="audio-card-content">' +
                      '<div class="audio-card-filename">No audio file</div>' +
                    '</div>' +
                  '</div>' +
                  '<div class="audio-card-actions">' +
                    '<button type="button" class="btn-audio-action btn-audio-upload">' +
                      '<i class="fa fa-upload"></i> ' + langUploadAudio +
                    '</button>' +
                  '</div>' +
                  '<div class="audio-file-input-wrapper show">' +
                    '<input type="file" name="ex_audio[]" accept="audio/mpeg,audio/wav">' +
                    '<div class="audio-file-feedback"></div>' +
                    '<small class="audio-help-text-card">' + langAudioOptional + '</small>' +
                  '</div>' +
                '</div>' +
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

    // ===== AUDIO CARD CONTROLS =====
    function initAudioCardControls() {
        var audioCards = document.querySelectorAll('.audio-card');
        
        audioCards.forEach(function(card) {
            initAudioCardEventHandlers(card);
        });
    }

    function initAudioCardEventHandlers(card) {
        var btnReplace = card.querySelector('.btn-audio-replace');
        var btnUpload = card.querySelector('.btn-audio-upload');
        var btnRemove = card.querySelector('.btn-audio-remove');
        var btnUndo = card.querySelector('.btn-audio-undo');
        var fileInput = card.querySelector('input[type="file"]');
        var deleteCheckbox = card.querySelector('input[type="hidden"][name="delete_audio"], input[type="hidden"][name^="ex_delete_audio"]');
        var fileInputWrapper = card.querySelector('.audio-file-input-wrapper');
        var fileFeedback = card.querySelector('.audio-file-feedback');
        
        // DEBUG: Log initialization
        console.log('[Dictionary Init] Audio card initialized');
        console.log('[Dictionary Init] Delete checkbox found:', deleteCheckbox);
        if (deleteCheckbox) {
            console.log('[Dictionary Init] Checkbox name:', deleteCheckbox.name, 'Initial value:', deleteCheckbox.value);
        }

        // Upload/Replace button click
        var uploadReplaceBtn = btnUpload || btnReplace;
        if (uploadReplaceBtn) {
            uploadReplaceBtn.addEventListener('click', function(e) {
                e.preventDefault();
                if (fileInputWrapper) {
                    fileInputWrapper.classList.toggle('show');
                    if (fileInputWrapper.classList.contains('show')) {
                        if (fileInput) fileInput.focus();
                    }
                }
            });
        }

        // File input change event
        if (fileInput) {
            fileInput.addEventListener('change', function() {
                if (this.files && this.files[0]) {
                    var filename = this.files[0].name;
                    if (fileFeedback) {
                        var isReplace = btnReplace !== null;
                        var message = isReplace ? 'New file selected: ' : 'File selected: ';
                        fileFeedback.textContent = message + filename;
                        fileFeedback.classList.add('show');
                    }
                } else {
                    if (fileFeedback) {
                        fileFeedback.classList.remove('show');
                        fileFeedback.textContent = '';
                    }
                }
            });
        }

        // Remove button click
        if (btnRemove) {
            btnRemove.addEventListener('click', function(e) {
                e.preventDefault();
                card.classList.add('audio-card-marked-delete');
                if (deleteCheckbox) {
                    // For hidden inputs, only set the value (not checked)
                    deleteCheckbox.value = 1;
                    console.log('[Dictionary] Remove clicked - set delete_audio to:', deleteCheckbox.value, 'Name:', deleteCheckbox.name);
                } else {
                    console.log('[Dictionary] ERROR: deleteCheckbox not found!');
                }
                // Hide file input when marked for deletion
                if (fileInputWrapper) {
                    fileInputWrapper.classList.remove('show');
                }
            });
        }

        // Undo button click
        if (btnUndo) {
            btnUndo.addEventListener('click', function(e) {
                e.preventDefault();
                card.classList.remove('audio-card-marked-delete');
                if (deleteCheckbox) {
                    // For hidden inputs, only set the value (not checked)
                    deleteCheckbox.value = 0;
                }
            });
        }
    }

    // Initialize audio card controls when page loads
    initAudioCardControls();

    // Also handle dynamically added example audio cards
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                mutation.addedNodes.forEach(function(node) {
                    if (node.nodeType === 1 && node.classList && node.classList.contains('example-item')) {
                        var audioCard = node.querySelector('.audio-card');
                        if (audioCard) {
                            initAudioCardEventHandlers(audioCard);
                        }
                    }
                });
            }
        });
    });

    var container = document.getElementById('examples-container');
    if (container) {
        observer.observe(container, { childList: true });
    }
});

