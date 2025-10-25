/**
 * NukeViet Dictionary Module JavaScript
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

(function($) {
    'use strict';
    
    // Module-level variables
    var $search_input = null;
    var $autocomplete_container = null;
    var $autocomplete_results = null;
    var $word_details_panel = null;
    var $intro_panel = null;
    var $search_loading = null;
    
    var typing_timer = null;
    var typing_delay = 300;
    var current_request = null;
    var selected_index = -1;
    var autocomplete_data = [];
    var current_audio = null;
    
    /**
     * Get configuration (lazy load to avoid timing issues)
     */
    function nv_dictionary_get_config() {
        return window.DICTIONARY_CONFIG || {};
    }
    
    /**
     * Escape HTML to prevent XSS
     */
    function nv_dictionary_escape_html(text) {
        if (!text) return '';
        var map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
    }
    
    /**
     * Stop any currently playing audio
     */
    function nv_dictionary_stop_audio() {
        if (current_audio) {
            current_audio.pause();
            current_audio.currentTime = 0;
            $('.dictionary-speaker-icon').removeClass('playing');
        }
    }
    
    /**
     * Play audio from URL
     */
    function nv_dictionary_play_audio(audio_url, $icon) {
        nv_dictionary_stop_audio();
        
        if (!audio_url) {
            return;
        }
        
        current_audio = new Audio(audio_url);
        
        $icon.addClass('playing');
        
        current_audio.addEventListener('ended', function() {
            $icon.removeClass('playing');
        });
        
        current_audio.addEventListener('error', function() {
            $icon.removeClass('playing').addClass('disabled');
            console.error('Error loading audio file:', audio_url);
        });
        
        current_audio.play().catch(function(error) {
            $icon.removeClass('playing');
            console.error('Error playing audio:', error);
        });
    }
    
    /**
     * Setup audio icon functionality
     */
    function nv_dictionary_setup_audio_icon($icon, audio_url) {
        $icon.show(); // ensure visible
        if (!audio_url) {
            $icon.removeClass('enabled playing').addClass('disabled').off('click');
            return;
        }
        
        $icon.removeClass('disabled').addClass('enabled');
        $icon.off('click').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            nv_dictionary_play_audio(audio_url, $(this));
        });
    }
    
    /**
     * Convert newlines to <br> tags
     */
    function nv_dictionary_nl2br(str) {
        if (!str) return '';
        return str.replace(/\n/g, '<br>');
    }
    
    /**
     * Show loading indicator
     */
    function nv_dictionary_show_loading() {
        $search_loading.show();
    }
    
    /**
     * Hide loading indicator
     */
    function nv_dictionary_hide_loading() {
        $search_loading.hide();
    }
    
    /**
     * Hide autocomplete dropdown
     */
    function nv_dictionary_hide_autocomplete() {
        $autocomplete_container.hide();
        selected_index = -1;
    }
    
    /**
     * Show intro panel
     */
    function nv_dictionary_show_intro() {
        $intro_panel.slideDown(300);
    }
    
    /**
     * Hide intro panel
     */
    function nv_dictionary_hide_intro() {
        $intro_panel.slideUp(300);
    }
    
    /**
     * Hide word details panel
     */
    function nv_dictionary_hide_word_details() {
        $word_details_panel.slideUp(300);
    }
    
    /**
     * Display no results message
     */
    function nv_dictionary_display_no_results() {
        var config = nv_dictionary_get_config();
        var no_results_text = (config.lang && config.lang.noResults) || 'No results found';
        $autocomplete_results.html('<div class="no-results">' + no_results_text + '</div>');
        $autocomplete_container.show();
    }
    
    /**
     * Display autocomplete results
     */
    function nv_dictionary_display_autocomplete_results(results) {
        $autocomplete_results.empty();
        
        if (results.length === 0) {
            nv_dictionary_display_no_results();
            return;
        }
        
        $.each(results, function(index, item) {
            var pos_html = item.pos ? '<span class="word-pos">' + nv_dictionary_escape_html(item.pos) + '</span>' : '';
            var $item = $('<li class="list-group-item" data-id="' + item.id + '">' +
                '<span class="word-text">' + nv_dictionary_escape_html(item.headword) + '</span>' +
                pos_html +
                '</li>');
            $autocomplete_results.append($item);
        });
        
        selected_index = -1;
        $autocomplete_container.show();
    }
    
    /**
     * Perform autocomplete search
     */
    function nv_dictionary_perform_autocomplete(query) {
        var config = nv_dictionary_get_config();
        
        // Validate config
        if (!config || !config.moduleUrl) {
            console.error('Dictionary config not found', config);
            return;
        }
        
        // Cancel previous request if exists
        if (current_request && current_request.abort) {
            try {
                current_request.abort();
            } catch (e) {
                // Ignore abort errors
            }
        }
        
        // Show loading indicator
        nv_dictionary_show_loading();
        
        // Make AJAX request
        current_request = $.ajax({
            url: config.moduleUrl,
            method: 'GET',
            data: {
                action: 'autocomplete',
                q: query
            },
            dataType: 'json',
            timeout: 10000,
            success: function(response) {
                nv_dictionary_hide_loading();
                
                if (response && response.status === 'success' && response.data) {
                    autocomplete_data = response.data;
                    nv_dictionary_display_autocomplete_results(response.data);
                } else {
                    nv_dictionary_display_no_results();
                }
            },
            error: function(xhr, status, error) {
                nv_dictionary_hide_loading();
                
                if (status !== 'abort') {
                    console.error('Autocomplete AJAX error:', {
                        status: status,
                        error: error,
                        xhr: xhr
                    });
                    nv_dictionary_display_no_results();
                }
            },
            complete: function() {
                current_request = null;
            }
        });
    }
    
    /**
     * Navigate autocomplete with keyboard
     */
    function nv_dictionary_navigate_autocomplete(direction) {
        var $items = $autocomplete_results.find('.list-group-item');
        
        if ($items.length === 0) {
            return;
        }
        
        $items.removeClass('active');
        
        if (direction === 'down') {
            selected_index = Math.min(selected_index + 1, $items.length - 1);
        } else if (direction === 'up') {
            selected_index = Math.max(selected_index - 1, -1);
        }
        
        if (selected_index >= 0) {
            $items.eq(selected_index).addClass('active');
        }
    }
    
    /**
     * Select highlighted autocomplete item
     */
    function nv_dictionary_select_highlighted_item() {
        var $active_item = $autocomplete_results.find('.list-group-item.active');
        
        if ($active_item.length > 0) {
            var word_id = $active_item.data('id');
            var text = $active_item.find('.word-text').text();
            $search_input.val(text);
            nv_dictionary_load_word_details(word_id);
            nv_dictionary_hide_autocomplete();
        } else if (autocomplete_data.length > 0) {
            // If no item selected, use first result
            $search_input.val(autocomplete_data[0].headword);
            nv_dictionary_load_word_details(autocomplete_data[0].id);
            nv_dictionary_hide_autocomplete();
        }
    }
    
    /**
     * Show word loading state
     */
    function nv_dictionary_show_word_loading() {
        var config = nv_dictionary_get_config();
        var loading_text = (config.lang && config.lang.loading) || 'Loading...';
        $('#word-headword').text(loading_text);
        $('#word-pos').hide();
        $('#word-phonetic-container').hide();
        $('#word-meaning').html('<i class="fa fa-spinner fa-spin"></i> ' + loading_text);
        $('#word-notes-container').hide();
        $('#word-examples-container').hide();
        $word_details_panel.show();
    }
    
    /**
     * Display word details
     */
    function nv_dictionary_display_word_details(data) {
        nv_dictionary_hide_intro();
        
        $('#word-headword').text(data.headword);
        $search_input.val(data.headword);
        
        if (data.pos) {
            $('#word-pos').text(data.pos).show();
        } else {
            $('#word-pos').hide();
        }
        
        if (data.phonetic) {
            $('#word-phonetic').text(data.phonetic);
            $('#word-phonetic-container').show();
        } else {
            $('#word-phonetic-container').hide();
        }
        
        var headword_audio_url = data.audio_url || '';
        var $headword_speaker = $('#headword-speaker');
        nv_dictionary_setup_audio_icon($headword_speaker, headword_audio_url);
        
        $('#word-meaning').html(nv_dictionary_nl2br(nv_dictionary_escape_html(data.meaning_vi)));
        
        if (data.notes && data.notes.trim() !== '') {
            $('#word-notes').html(nv_dictionary_nl2br(nv_dictionary_escape_html(data.notes)));
            $('#word-notes-container').show();
        } else {
            $('#word-notes-container').hide();
        }
        
        if (data.examples && data.examples.length > 0) {
            var examples_html = '';
            $.each(data.examples, function(index, example) {
                var example_audio_url = example.audio_url || '';
                var speaker_disabled_class = example_audio_url ? 'enabled' : 'disabled';
                var speaker_icon_html = '<i class="dictionary-speaker-icon dictionary-example-speaker ' + 
                    speaker_disabled_class + ' fa fa-volume-up" data-audio-url="' + 
                    nv_dictionary_escape_html(example_audio_url) + '"></i>';
                
                examples_html += '<div class="dictionary-example-item">';
                examples_html += '<div class="dictionary-example-en">' + 
                    speaker_icon_html + ' ' +
                    nv_dictionary_escape_html(example.sentence_en) + '</div>';
                if (example.translation_vi) {
                    examples_html += '<div class="dictionary-example-vi">' + 
                        nv_dictionary_escape_html(example.translation_vi) + '</div>';
                }
                examples_html += '</div>';
            });
            
            $('#word-examples-list').html(examples_html);
            
            $('#word-examples-list').find('.dictionary-example-speaker').each(function() {
                var $speaker = $(this);
                var audio_url = $speaker.data('audio-url');
                nv_dictionary_setup_audio_icon($speaker, audio_url);
            });
            
            $('#word-examples-container').show();
        } else {
            $('#word-examples-container').hide();
        }
        
        $word_details_panel.slideDown(300);
    }
    
    /**
     * Load word details
     */
    function nv_dictionary_load_word_details(word_id) {
        var config = nv_dictionary_get_config();
        
        // Show loading in panel
        nv_dictionary_show_word_loading();
        
        $.ajax({
            url: config.moduleUrl,
            method: 'GET',
            data: {
                action: 'getword',
                id: word_id
            },
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success' && response.data) {
                    nv_dictionary_display_word_details(response.data);
                } else {
                    alert(response.message || 'Error loading word details');
                }
            },
            error: function(xhr, status, error) {
                console.error('Word details error:', error);
                alert('Error loading word details. Please try again.');
            }
        });
    }
    
    /**
     * Handle typing in search input
     */
    function nv_dictionary_handle_typing(e) {
        var key = e.which || e.keyCode;
        
        // Handle special keys only on keyup
        if (e.type === 'keyup') {
            if (key === 38) { // Up arrow
                e.preventDefault();
                nv_dictionary_navigate_autocomplete('up');
                return false;
            } else if (key === 40) { // Down arrow
                e.preventDefault();
                nv_dictionary_navigate_autocomplete('down');
                return false;
            } else if (key === 13) { // Enter
                e.preventDefault();
                nv_dictionary_select_highlighted_item();
                return false;
            } else if (key === 27) { // Escape
                nv_dictionary_hide_autocomplete();
                return false;
            }
        }
        
        // Clear previous timer
        if (typing_timer) {
            clearTimeout(typing_timer);
        }
        
        var query = $(this).val().trim();
        
        if (query.length === 0) {
            nv_dictionary_hide_autocomplete();
            nv_dictionary_hide_word_details();
            nv_dictionary_show_intro();
            return;
        }
        
        // Set new timer for autocomplete
        typing_timer = setTimeout(function() {
            try {
                nv_dictionary_perform_autocomplete(query);
            } catch (err) {
                console.error('Autocomplete error:', err);
            }
        }, typing_delay);
    }
    
    /**
     * Initialize the dictionary module
     */
    function nv_dictionary_init() {
        // Cache DOM elements
        $search_input = $('#dictionary-search-input');
        $autocomplete_container = $('#dictionary-autocomplete');
        $autocomplete_results = $('#autocomplete-results');
        $word_details_panel = $('#word-details-panel');
        $intro_panel = $('#dictionary-intro-panel');
        $search_loading = $('#search-loading');
        
        // Bind events
        
        // Bind both input and keyup events for maximum compatibility
        $search_input.on('input keyup', nv_dictionary_handle_typing);
        
        // Click outside to close autocomplete
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.dictionary-search-container').length) {
                nv_dictionary_hide_autocomplete();
            }
        });
        
        // Autocomplete item click event (delegated)
        $autocomplete_results.on('click', '.list-group-item', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            // Hide autocomplete immediately
            nv_dictionary_hide_autocomplete();
            
            // Clear any pending autocomplete timer
            if (typing_timer) {
                clearTimeout(typing_timer);
                typing_timer = null;
            }
            
            var word_id = $(this).data('id');
            var text = $(this).find('.word-text').text();
            $search_input.val(text);
            nv_dictionary_load_word_details(word_id);
        });
        
        // Autocomplete item hover
        $autocomplete_results.on('mouseenter', '.list-group-item', function() {
            $autocomplete_results.find('.list-group-item').removeClass('active');
            $(this).addClass('active');
            selected_index = $(this).index();
        });
    }
    
    // Initialize when document is ready
    $(document).ready(function() {
        nv_dictionary_init();
    });
    
})(jQuery);
