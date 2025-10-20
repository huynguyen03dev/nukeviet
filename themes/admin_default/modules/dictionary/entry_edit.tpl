<!-- BEGIN: main -->
<!-- Dictionary: Add/Edit Entry Form -->
<div class="panel panel-default">
  <div class="panel-heading">
    <strong>{LANG.edit}</strong>
  </div>
  <div class="panel-body" 
       data-lang-example="{LANG.example}" 
       data-lang-remove-example="{LANG.remove_example}"
       data-lang-example-sentence="{LANG.example_sentence}"
       data-lang-example-translation="{LANG.example_translation}"
       data-lang-example-sentence-placeholder="{LANG.example_sentence_placeholder}"
       data-lang-example-translation-placeholder="{LANG.example_translation_placeholder}"
       data-lang-example-audio="{LANG.example_audio}"
       data-lang-audio-optional="{LANG.audio_optional}">
    <!-- Errors -->
    <!-- BEGIN: errors -->
    <div class="alert alert-danger">
      <ul style="margin:0; padding-left:18px;">
        <!-- BEGIN: loop -->
        <li>{ERROR}</li>
        <!-- END: loop -->
      </ul>
    </div>
    <!-- END: errors -->

    <form action="{ACTION}" method="post" class="form-horizontal" role="form" novalidate enctype="multipart/form-data">
      <input type="hidden" name="{NV_LANG_VARIABLE}" value="{NV_LANG_DATA}">
      <input type="hidden" name="{NV_NAME_VARIABLE}" value="{MODULE_NAME}">
      <input type="hidden" name="{NV_OP_VARIABLE}" value="{OP}">
      <input type="hidden" name="id" value="{ID}">
      <input type="hidden" name="checkss" value="{CHECKSS}">

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.headword} <sup class="required">(*)</sup></label>
        <div class="col-sm-9">
          <input type="text" name="headword" value="{HEADWORD}" class="form-control" required>
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.slug}</label>
        <div class="col-sm-9">
          <input type="text" name="slug" value="{SLUG}" class="form-control" placeholder="{LANG.slug_auto_generate}">
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.pos}</label>
        <div class="col-sm-9">
          <input type="text" name="pos" value="{POS}" class="form-control" placeholder="{LANG.pos_placeholder}">
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.phonetic}</label>
        <div class="col-sm-9">
          <input type="text" name="phonetic" value="{PHONETIC}" class="form-control" placeholder="{LANG.phonetic_placeholder}">
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.upload_audio}</label>
        <div class="col-sm-9">
          <!-- BEGIN: current_audio -->
          <div class="current-audio-file">
            <strong>{LANG.current_audio}:</strong> 
            <a href="{AUDIO_URL}" target="_blank">{AUDIO_FILE}</a>
            <audio controls style="display:block; margin-top:5px; max-width:100%;">
              <source src="{AUDIO_URL}" type="audio/mpeg">
            </audio>
          </div>
          <!-- END: current_audio -->
          <input type="file" name="audio" class="form-control" accept="audio/mpeg,audio/wav">
          <small class="help-block">{LANG.audio_optional}</small>
          <!-- BEGIN: delete_audio -->
          <label style="margin-top:10px;">
            <input type="checkbox" name="delete_audio" value="1"> {LANG.delete_audio}
          </label>
          <!-- END: delete_audio -->
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.meaning_vi} <sup class="required">(*)</sup></label>
        <div class="col-sm-9">
          <textarea name="meaning_vi" rows="4" class="form-control" required>{MEANING_VI}</textarea>
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.notes}</label>
        <div class="col-sm-9">
          <textarea name="notes" rows="3" class="form-control">{NOTES}</textarea>
        </div>
      </div>

      <hr>
      <div class="form-group">
        <label class="col-sm-3 control-label">{LANG.examples}</label>
        <div class="col-sm-9">
          <div id="examples-wrapper">
            <div id="examples-container">
              <!-- BEGIN: example -->
              <div class="example-item">
                <input type="hidden" name="ex_id[]" value="{EXAMPLE.id}">
                <div class="example-header">
                  <span class="example-number">{LANG.example} {EXAMPLE.num}</span>
                  <button type="button" class="example-remove-btn" data-remove-example aria-label="{LANG.remove_example}" title="{LANG.remove_example}">&times;</button>
                </div>
                <div class="example-row">
                  <label>{LANG.example_sentence}</label>
                  <input type="text" name="ex_sentence_en[]" placeholder="{LANG.example_sentence_placeholder}" value="{EXAMPLE.sentence_en}">
                </div>
                <div class="example-row">
                  <label>{LANG.example_translation}</label>
                  <input type="text" name="ex_translation_vi[]" placeholder="{LANG.example_translation_placeholder}" value="{EXAMPLE.translation_vi}">
                </div>
                <div class="example-row">
                  <label>{LANG.example_audio}</label>
                  <!-- BEGIN: current_example_audio -->
                  <div class="current-audio-file" style="margin-bottom:5px;">
                    <strong>{LANG.current_audio}:</strong> 
                    <a href="{EXAMPLE.audio_url}" target="_blank">{EXAMPLE.audio_file}</a>
                    <audio controls style="display:block; margin-top:5px; max-width:100%;">
                      <source src="{EXAMPLE.audio_url}" type="audio/mpeg">
                    </audio>
                    <label style="margin-top:5px;">
                      <input type="checkbox" name="ex_delete_audio[]" value="{EXAMPLE.id}"> {LANG.delete_audio}
                    </label>
                  </div>
                  <!-- END: current_example_audio -->
                  <input type="file" name="ex_audio[]" accept="audio/mpeg,audio/wav">
                  <small class="help-block">{LANG.audio_optional}</small>
                </div>
              </div>
              <!-- END: example -->
            </div>
            <div class="examples-add-button-wrapper">
              <button type="button" class="btn btn-success btn-sm" id="btn-add-example">
                <i class="fa fa-plus"></i> {LANG.add_example}
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <div class="col-sm-offset-3 col-sm-9">
          <button type="submit" name="submit" value="1" class="btn btn-primary">{GLANG.save}</button>
          <a href="{ACTION}?{NV_LANG_VARIABLE}={NV_LANG_DATA}&{NV_NAME_VARIABLE}={MODULE_NAME}&{NV_OP_VARIABLE}=main" class="btn btn-default">{GLANG.cancel}</a>
        </div>
      </div>
    </form>
  </div>
</div>
<!-- END: main -->
