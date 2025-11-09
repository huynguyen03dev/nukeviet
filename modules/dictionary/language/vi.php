<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$lang_translator['author'] = 'VINADES.,JSC <contact@vinades.vn>';
$lang_translator['createdate'] = '20/07/2023, 07:15';
$lang_translator['copyright'] = '@Copyright (C) 2010 VINADES.,JSC. All rights reserved';
$lang_translator['info'] = '';
$lang_translator['langtype'] = 'lang_module';

// Page titles
$lang_module['add'] = 'Thêm từ mới';
$lang_module['edit'] = 'Sửa từ';
$lang_module['list'] = 'Danh sách từ điển';

// Form fields
$lang_module['headword'] = 'Từ tiếng Anh';
$lang_module['slug'] = 'Đường dẫn URL';
$lang_module['pos'] = 'Từ loại';
$lang_module['phonetic'] = 'Phiên âm';
$lang_module['meaning_vi'] = 'Nghĩa tiếng Việt';
$lang_module['notes'] = 'Ghi chú';
$lang_module['examples'] = 'Ví dụ';
$lang_module['example_sentence'] = 'Câu ví dụ (EN)';
$lang_module['example_translation'] = 'Dịch nghĩa (VI)';

// Placeholders
$lang_module['slug_auto_generate'] = 'Tự động tạo nếu để trống';
$lang_module['pos_placeholder'] = 'VD: n., v., adj.';
$lang_module['phonetic_placeholder'] = '/fəˈnɛtɪk/';
$lang_module['example_sentence_placeholder'] = 'Câu ví dụ tiếng Anh';
$lang_module['example_translation_placeholder'] = 'Dịch nghĩa tiếng Việt (tùy chọn)';

// Buttons
$lang_module['add_example'] = 'Thêm ví dụ';
$lang_module['remove_example'] = 'Xóa ví dụ';
$lang_module['save'] = 'Lưu lại';
$lang_module['cancel'] = 'Hủy bỏ';
$lang_module['delete'] = 'Xóa';

// Validation messages
$lang_module['error_empty_headword'] = 'Vui lòng nhập từ tiếng Anh';
$lang_module['error_empty_meaning'] = 'Vui lòng nhập nghĩa tiếng Việt';

// Success messages
$lang_module['success_add'] = 'Thêm từ thành công';
$lang_module['success_edit'] = 'Cập nhật từ thành công';
$lang_module['success_delete'] = 'Xóa từ thành công';
$lang_module['entry_added_success'] = 'Từ "%s" đã được thêm thành công';
$lang_module['entry_updated_success'] = 'Từ "%s" đã được cập nhật thành công';
$lang_module['entry_deleted_success'] = 'Từ "%s" đã được xóa thành công';
$lang_module['errorsave'] = 'Đã xảy ra lỗi khi lưu dữ liệu';

// Notifications
$lang_module['notif_entry_added'] = 'Đã thêm từ mới: {title}';
$lang_module['notif_entry_updated'] = 'Đã cập nhật từ: {title}';
$lang_module['notif_entry_deleted'] = 'Đã xóa từ: {title}';

// Common
$lang_module['example'] = 'Ví dụ';
$lang_module['search'] = 'Tìm kiếm';
$lang_module['actions'] = 'Thao tác';
$lang_module['status'] = 'Trạng thái';
$lang_module['created_at'] = 'Ngày tạo';
$lang_module['updated_at'] = 'Cập nhật';
$lang_module['add_time'] = 'Thời gian đăng';
$lang_module['no_data'] = 'Không có dữ liệu';

// Search
$lang_module['search_placeholder'] = 'Tìm kiếm theo từ, nghĩa hoặc từ loại...';
$lang_module['searching'] = 'Đang tìm kiếm...';

// Main page
$lang_module['main_intro'] = 'Tìm kiếm từ tiếng Anh để xem nghĩa tiếng Việt và ví dụ.';
$lang_module['type_to_search'] = 'Nhập từ để tìm kiếm...';
$lang_module['no_results'] = 'Không tìm thấy từ nào phù hợp';
$lang_module['loading'] = 'Đang tải...';
$lang_module['select_word'] = 'Chọn một từ từ danh sách gợi ý';
$lang_module['back_to_search'] = 'Quay lại Tìm kiếm';

// Audio
$lang_module['audio_pronunciation'] = 'Phát âm';
$lang_module['play_pronunciation'] = 'Phát âm thanh';
$lang_module['upload_audio'] = 'Tải lên âm thanh';
$lang_module['audio_optional'] = 'Tùy chọn - MP3 hoặc WAV, tối đa 5MB';
$lang_module['current_audio'] = 'Tệp âm thanh hiện tại';
$lang_module['replace_audio'] = 'Thay thế âm thanh';
$lang_module['delete_audio'] = 'Xóa âm thanh';
$lang_module['example_audio'] = 'Âm thanh ví dụ';

// Audio UI - buttons and messages
$lang_module['upload_audio_btn'] = 'Tải lên âm thanh';
$lang_module['replace_audio_btn'] = 'Thay thế âm thanh';
$lang_module['remove_audio_btn'] = 'Xóa';
$lang_module['undo_remove_audio_btn'] = 'Hoàn tác';
$lang_module['will_be_deleted'] = 'Sẽ bị xóa khi lưu';
$lang_module['new_file_selected'] = 'Tệp mới được chọn: {filename}';
$lang_module['file_selected'] = 'Tệp được chọn: {filename}';

// Audio - errors
$lang_module['error_audio_size'] = 'Kích thước tệp âm thanh vượt quá 5MB';
$lang_module['error_audio_type'] = 'Chỉ cho phép tệp MP3 và WAV';
$lang_module['error_audio_upload'] = 'Không thể tải lên tệp âm thanh';
$lang_module['error_audio_upload_failed'] = 'Tải lên tệp âm thanh thất bại. Vui lòng thử lại.';
$lang_module['error_audio_move_failed'] = 'Tệp âm thanh đã tải lên nhưng không thể lưu vào vị trí cuối cùng.';
$lang_module['error_audio_delete_failed'] = 'Không thể xóa tệp âm thanh cũ (tệp có thể bị thiếu).';
$lang_module['error_audio_not_found'] = 'Không tìm thấy tệp âm thanh được yêu cầu.';
// Task 4.6-4.10 & 5.9: New error and success messages for audio upload fixes (Vietnamese translations)
$lang_module['error_audio_file_not_found'] = 'Không tìm thấy tệp âm thanh sau khi tải lên. Vui lòng thử lại.';
$lang_module['error_audio_directory_not_writable'] = 'Thư mục tải lên không có quyền ghi. Vui lòng liên hệ quản trị viên.';
$lang_module['entry_added_success_with_audio'] = 'Từ "%s" đã được thêm thành công với phát âm.';
$lang_module['error_example_audio_failed'] = 'Không thể lưu âm thanh cho ví dụ #%d.';
$lang_module['entry_updated_success_with_audio'] = 'Từ "%s" đã được cập nhật thành công với phát âm.';
$lang_module['download_audio'] = 'Tải xuống âm thanh';
