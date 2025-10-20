<!-- BEGIN: main -->
<div class="dictionary-main">
    <!-- Search Section -->
    <div class="dictionary-search-section">
        <div class="dictionary-search-wrapper">
            <div class="dictionary-search-container">
                <input type="text" 
                       id="dictionary-search-input" 
                       class="dictionary-search-input" 
                       placeholder="{LANG.type_to_search}"
                       autocomplete="off">
                <i class="fa fa-search dictionary-search-icon"></i>
                <span id="search-loading" class="dictionary-search-loading" style="display:none;">
                    <i class="fa fa-spinner fa-spin"></i>
                </span>
                
                <!-- Autocomplete Dropdown -->
                <div id="dictionary-autocomplete" class="dictionary-autocomplete" style="display:none;">
                    <ul class="list-group" id="autocomplete-results"></ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Introduction Panel (shown by default, hidden when word selected) -->
    <div id="dictionary-intro-panel" class="panel panel-default">
        <div class="panel-body text-center">
            <p class="lead dictionary-intro-text">{INTRO_TEXT}</p>
        </div>
    </div>

    <!-- Word Details Panel (Hidden by default, replaces intro when word selected) -->
    <div id="word-details-panel" class="panel panel-primary" style="display:none;">
        <div class="panel-heading">
            <h3 class="panel-title">
                <span id="word-headword"></span>
                <i class="fa fa-volume-up dictionary-speaker-icon" id="headword-speaker" style="display:none;" title="{LANG.play_pronunciation}"></i>
                <span id="word-pos" class="badge"></span>
            </h3>
        </div>
        <div class="panel-body">
            <!-- Hidden audio element for headword -->
            <audio id="headword-audio" preload="none" style="display:none;"></audio>
            
            <!-- Phonetic -->
            <div id="word-phonetic-container" style="display:none;">
                <p class="dictionary-phonetic">
                    <em id="word-phonetic"></em>
                </p>
            </div>

            <!-- Vietnamese Meaning -->
            <div class="dictionary-meaning">
                <h4>{LANG.meaning_vi}</h4>
                <p id="word-meaning" class="lead"></p>
            </div>

            <!-- Notes -->
            <div id="word-notes-container" class="dictionary-notes" style="display:none;">
                <h4>{LANG.notes}</h4>
                <p id="word-notes"></p>
            </div>

            <!-- Examples -->
            <div id="word-examples-container" class="dictionary-examples" style="display:none;">
                <h4>{LANG.examples}</h4>
                <div id="word-examples-list"></div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
var DICTIONARY_CONFIG = {
    moduleUrl: '{NV_BASE_SITEURL}index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&{NV_NAME_VARIABLE}={MODULE_NAME}',
    lang: {
        noResults: '{LANG.no_results}',
        loading: '{LANG.loading}',
        selectWord: '{LANG.select_word}'
    }
};
</script>
<!-- END: main -->

