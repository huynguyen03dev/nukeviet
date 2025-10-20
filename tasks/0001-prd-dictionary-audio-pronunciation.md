# PRD: Dictionary Audio Pronunciation Feature

## Introduction/Overview

This feature adds audio pronunciation support to the dictionary module, allowing users to listen to the correct pronunciation of English words and their example sentences. Users will be able to click speaker icons to play audio files that demonstrate proper pronunciation, enhancing the learning experience and making the dictionary more useful for language learners.

The admin interface will provide a simple upload mechanism for audio files when creating or editing dictionary entries.

## Goals

1. Enable users to hear proper pronunciation of English words
2. Provide audio examples for sentence usage
3. Implement an intuitive, simple audio playback interface
4. Create an easy-to-use admin interface for uploading audio files
5. Support multiple audio formats (MP3 and WAV)

## User Stories

**As a dictionary user, I want to:**
- Click a speaker icon next to a word to hear its pronunciation, so that I can learn how to say it correctly
- Click speaker icons next to example sentences to hear natural usage, so that I can understand context and intonation
- See which words/examples have audio available (even if not yet uploaded), so that I know what content exists

**As a dictionary administrator, I want to:**
- Upload audio files when adding new dictionary entries, so that users can hear pronunciations
- Upload audio files when editing existing entries, so that I can add pronunciation support over time
- Upload separate audio files for each example sentence, so that each example can be heard individually
- Have the system validate uploaded files, so that only proper audio files are accepted

## Functional Requirements

### Public/Site Side

1. The system must display a speaker icon button next to each headword
2. The system must display a speaker icon button next to each example sentence
3. The speaker icon must be clickable and play the associated audio file when an audio file exists
4. The speaker icon must be disabled/greyed out when no audio file has been uploaded yet
5. The system must support playback of MP3 audio files
6. The system must support playback of WAV audio files
7. The audio player must use the browser's native audio capabilities (HTML5 audio)
8. If an example sentence does not have an uploaded audio file, the speaker icon should still appear but be disabled

### Admin Side

9. The add/edit entry form must include an optional file upload field for headword pronunciation
10. The add/edit entry form must include an optional file upload field for each example sentence's pronunciation
11. When multiple example sentences exist, each must have its own separate audio upload field
12. The system must validate that uploaded files are actual audio files (not images, documents, etc.)
13. The system must enforce a maximum file size limit of 5MB per audio file
14. The system must display an error message if file validation fails (wrong format or too large)
15. The system must show the current audio filename if an audio file already exists for an entry
16. The system must allow administrators to replace existing audio files with new uploads
17. The system must allow administrators to delete existing audio files
18. All audio file uploads must be optional (entries can be saved without audio)

### Technical Requirements

19. Audio files must be stored in a dedicated directory structure (e.g., `/uploads/dictionary/audio/`)
20. Audio filenames must be unique to prevent conflicts
21. When a dictionary entry is deleted, associated audio files must also be deleted
22. The system must handle cases where audio files are missing or corrupted gracefully (show disabled icon, no errors)

## Non-Goals (Out of Scope)

1. **Automatic audio generation** - We will not integrate text-to-speech APIs or auto-generate pronunciations
2. **Multiple pronunciations per word** - Only one audio file per headword (e.g., no British vs American variants)
3. **Audio for word meanings/definitions** - Only headword and examples get audio
4. **Batch audio upload** - No bulk import or processing of multiple audio files at once
5. **Audio editing** - No built-in tools to trim, adjust volume, or edit audio files
6. **Multi-language support** - Only English pronunciation for this version
7. **Waveform visualization** - Simple play button only, no visual representation of audio
8. **Download audio** - Users cannot download audio files, only play them in browser
9. **Phonetic transcription sync** - Audio is independent of phonetic text field

## Design Considerations

### User Interface
- Use a standard speaker/volume icon (FontAwesome or similar)
- Icon should be small and unobtrusive, positioned inline next to the text
- Disabled state should be visually distinct (greyed out, reduced opacity)
- Active/playing state should provide visual feedback (color change or animation)

### Admin Interface
- Follow existing NukeViet admin form patterns
- Use standard file upload input fields
- Group audio uploads logically (headword audio separate from example audios)
- Display clear labels indicating the field is optional
- Show current filename if audio exists, with option to replace or remove

### Responsive Design
- Audio controls must work on mobile devices
- Touch-friendly speaker icon sizing
- Consider mobile data usage (show file size?)

## Technical Considerations

### File Storage
- Store audio files in `/uploads/dictionary/audio/` directory
- Use naming convention: `{entry_id}_headword.{ext}` for headwords
- Use naming convention: `{entry_id}_example_{example_id}.{ext}` for examples
- Implement proper file permissions and security

### Database Schema
- Add `audio_file` column to dictionary entries table (VARCHAR for headword audio filename)
- Add `audio_file` column to examples table (VARCHAR for example audio filename)
- Both fields should be nullable (audio is optional)

### Security
- Validate file MIME types on server side
- Sanitize filenames to prevent directory traversal
- Restrict upload directory permissions appropriately
- Implement file size limits to prevent abuse

### Integration Points
- Must integrate with existing dictionary module structure
- Follow NukeViet theme/template conventions
- Use existing XTemplate system for rendering speaker icons

### Performance
- Audio files should not significantly impact page load time
- Use lazy loading if possible (load audio only when play button clicked)
- Consider CDN or optimized delivery for future scaling

## Success Metrics

1. **Feature Adoption**: 80% of new dictionary entries include audio for the headword within 3 months
2. **User Engagement**: Track number of audio plays per dictionary entry view
3. **Error Rate**: Less than 1% of audio playback attempts result in errors
4. **Admin Usability**: Audio upload process takes less than 30 seconds per entry
5. **File Quality**: Less than 5% of uploaded audio files require replacement due to quality issues

## Open Questions

1. Should there be any naming conventions or guidelines for audio file quality (bitrate, sample rate)?
2. Do we need an admin report showing which entries are missing audio files?
3. Should there be a preview/test play function in the admin panel before saving?
4. Is there a preferred audio recording tool or guideline we should recommend to admins?
5. Should we display audio file size to users on the public side?
6. Do we need any analytics/tracking for which pronunciations are played most often?

---

**Document Version**: 1.0  
**Created**: October 18, 2025  
**Target Module**: Dictionary  
**Priority**: Medium  
**Estimated Complexity**: Low-Medium
