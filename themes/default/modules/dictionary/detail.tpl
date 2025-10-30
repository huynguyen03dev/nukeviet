<!-- BEGIN: main -->
<div class="dictionary-main">
    <!-- BEGIN: error -->
    <!-- Error state - entry not found -->
    <div class="panel panel-default">
        <div class="panel-body text-center">
            <p class="lead">{LANG.no_results}</p>
            <a href="{MODULE_URL}" class="btn btn-primary">{LANG.back_to_search}</a>
        </div>
    </div>
    <!-- END: error -->

    <!-- BEGIN: word_details -->
    <!-- Word Details Panel -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">
                <span>{DATA.headword}</span>
                <!-- BEGIN: has_audio -->
                <i class="fa fa-volume-up dictionary-speaker-icon enabled" 
                   id="headword-speaker" 
                   title="{LANG.play_pronunciation}"
                   data-audio-url="{DATA.audio_url}"></i>
                <!-- END: has_audio -->
                <!-- BEGIN: no_audio -->
                <i class="fa fa-volume-up dictionary-speaker-icon disabled" 
                   title="{LANG.play_pronunciation}"></i>
                <!-- END: no_audio -->
                <!-- BEGIN: has_pos -->
                <span class="badge">{DATA.pos}</span>
                <!-- END: has_pos -->
            </h3>
        </div>
        <div class="panel-body">
            <!-- Hidden audio element for headword -->
            <!-- BEGIN: has_audio -->
            <audio id="headword-audio" preload="none" class="dictionary-hidden"></audio>
            <!-- END: has_audio -->
            
            <!-- Phonetic -->
            <!-- BEGIN: has_phonetic -->
            <div class="word-phonetic-container">
                <p class="dictionary-phonetic">
                    <em>{DATA.phonetic}</em>
                </p>
            </div>
            <!-- END: has_phonetic -->

            <!-- Vietnamese Meaning -->
            <div class="dictionary-meaning">
                <h4>{LANG.meaning_vi}</h4>
                <p class="lead">{DATA.meaning_vi}</p>
            </div>

            <!-- Notes -->
            <!-- BEGIN: has_notes -->
            <div class="word-notes-container dictionary-notes">
                <h4>{LANG.notes}</h4>
                <p>{DATA.notes}</p>
            </div>
            <!-- END: has_notes -->
            <!-- BEGIN: no_notes -->
            <!-- Notes section placeholder - kept for consistent spacing -->
            <!-- END: no_notes -->

            <!-- Examples -->
            <!-- BEGIN: has_examples -->
            <div class="word-examples-container dictionary-examples">
                <h4>{LANG.examples}</h4>
                <div class="word-examples-list">
                    <!-- BEGIN: example_loop -->
                    <div class="dictionary-example-item">
                        <div class="dictionary-example-en">
                            {EXAMPLE.sentence_en}
                            <!-- BEGIN: example_has_audio -->
                            <i class="fa fa-volume-up dictionary-speaker-icon enabled dictionary-example-speaker" 
                               title="{LANG.play_pronunciation}"
                               data-audio-url="{EXAMPLE.audio_url}"></i>
                            <!-- END: example_has_audio -->
                            <!-- BEGIN: example_no_audio -->
                            <i class="fa fa-volume-up dictionary-speaker-icon disabled dictionary-example-speaker" 
                               title="{LANG.play_pronunciation}"></i>
                            <!-- END: example_no_audio -->
                        </div>
                        <!-- BEGIN: example_has_translation -->
                        <div class="dictionary-example-vi">{EXAMPLE.translation_vi}</div>
                        <!-- END: example_has_translation -->
                        <!-- BEGIN: example_has_audio -->
                        <audio class="dictionary-hidden" preload="none" data-example-id="{EXAMPLE.id}"></audio>
                        <!-- END: example_has_audio -->
                    </div>
                    <!-- END: example_loop -->
                </div>
            </div>
            <!-- END: has_examples -->
            <!-- BEGIN: no_examples -->
            <!-- Examples section placeholder - kept for consistent spacing -->
            <!-- END: no_examples -->
        </div>
    </div>

    <!-- Back to Search Button -->
    <div class="text-center" style="margin-top: 20px;">
        <a href="{MODULE_URL}" class="btn btn-default">
            <i class="fa fa-arrow-left"></i> {LANG.back_to_search}
        </a>
    </div>
    <!-- END: word_details -->
</div>

<!-- Audio playback JavaScript -->
<script>
(function($) {
    'use strict';
    
    // Audio playback functionality (reused from main page)
    var current_audio = null;
    
    function play_audio(audio_url, $icon) {
        if (!audio_url) {
            return;
        }
        
        // Stop current audio if playing
        if (current_audio) {
            current_audio.pause();
            current_audio.currentTime = 0;
            $('.dictionary-speaker-icon').removeClass('playing');
        }
        
        current_audio = new Audio(audio_url);
        
        $icon.addClass('playing');
        
        current_audio.play().then(function() {
            // Success
        }).catch(function(error) {
            console.error('Error loading audio file:', audio_url);
            $icon.removeClass('playing');
        });
        
        current_audio.addEventListener('ended', function() {
            $icon.removeClass('playing');
            current_audio = null;
        });
        
        current_audio.addEventListener('error', function() {
            $icon.removeClass('playing');
            current_audio = null;
        });
    }
    
    // Setup audio icon click handlers
    $(document).ready(function() {
        $('.dictionary-speaker-icon.enabled').on('click', function() {
            var $icon = $(this);
            var audio_url = $icon.data('audio-url');
            if (audio_url) {
                play_audio(audio_url, $icon);
            }
        });
    });
})(jQuery);
</script>
<!-- END: main -->

