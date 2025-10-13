<!-- BEGIN: main -->
<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <caption><em class="fa fa-file-text-o">&nbsp;</em>{LANG.list}</caption>
        <colgroup>
            <col span="1" style="width: 5%;">
            <col span="1" style="width: 25%;">
            <col span="1" style="width: 15%;">
            <col span="1" style="width: 25%;">
            <col span="1" style="width: 15%;">
            <col span="1" style="width: 15%;">
        </colgroup>
        <thead>
            <tr>
                <th class="text-center">#</th>
                <th>{LANG.headword}</th>
                <th>{LANG.pos}</th>
                <th>{LANG.meaning_vi}</th>
                <th class="text-center">{LANG.created_at}</th>
                <th class="text-center">{LANG.actions}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
            <tr>
                <td class="text-center">{ROW.num}</td>
                <td>
                    <strong>{ROW.headword}</strong>
                    <!-- BEGIN: phonetic -->
                    <br><small class="text-muted">{ROW.phonetic}</small>
                    <!-- END: phonetic -->
                </td>
                <td>{ROW.pos}</td>
                <td>{ROW.meaning_vi}</td>
                <td class="text-center">{ROW.created_at}</td>
                <td class="text-center">
                    <a href="{ROW.url_edit}" class="btn btn-default btn-xs" title="{LANG.edit}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a href="javascript:void(0);" onclick="nv_delete_entry({ROW.id});" class="btn btn-danger btn-xs" title="{LANG.delete}">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </td>
            </tr>
            <!-- END: loop -->
            <!-- BEGIN: empty -->
            <tr>
                <td colspan="6" class="text-center">
                    <em>{LANG.no_data}</em>
                </td>
            </tr>
            <!-- END: empty -->
        </tbody>
    </table>
</div>

<div class="form-inline text-center">
    <a href="{ADD_URL}" class="btn btn-primary">
        <i class="fa fa-plus"></i> {LANG.add}
    </a>
</div>

<!-- BEGIN: page -->
<div class="text-center">{NV_GENERATE_PAGE}</div>
<!-- END: page -->

<script type="text/javascript">
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
</script>
<!-- END: main -->
