<!-- BEGIN: main -->
<!-- Dictionary: Add/Edit Entry Form -->
<div class="panel panel-default">
  <div class="panel-heading">
    <strong>{LANG.add}</strong>
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
      <ul>
        <!-- BEGIN: loop -->
        <li>{ERROR}</li>
        <!-- END: loop -->
      </ul>
    </div>
    <!-- END: errors -->

    <form action="{ACTION}" method="post" enctype="multipart/form-data" class="form-horizontal" role="form" novalidate>
      <input type="hidden" name="{NV_LANG_VARIABLE}" value="{NV_LANG_DATA}">
      <input type="hidden" name="{NV_NAME_VARIABLE}" value="{MODULE_NAME}">
      <input type="hidden" name="{NV_OP_VARIABLE}" value="{OP}">
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
          <div class="audio-card audio-card-empty">
            <div class="audio-card-header">
              <span class="audio-card-icon"><i class="fa fa-music"></i></span>
              <div class="audio-card-content">
                <div class="audio-card-filename">No audio file</div>
              </div>
            </div>
            <div class="audio-card-actions">
              <button type="button" class="btn-audio-action btn-audio-upload">
                <i class="fa fa-upload"></i> {LANG.upload_audio_btn}
              </button>
            </div>
            <div class="audio-file-input-wrapper show">
              <input type="file" name="audio" accept="audio/mpeg,audio/wav">
              <div class="audio-file-feedback"></div>
              <small class="audio-help-text-card">{LANG.audio_optional}</small>
            </div>
          </div>
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
            <div class="examples-add-button-wrapper">
              <button type="button" class="btn btn-success btn-sm" id="btn-add-example">
                <i class="fa fa-plus"></i> {LANG.add_example}
              </button>
            </div>
            <div id="examples-container"></div>
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

