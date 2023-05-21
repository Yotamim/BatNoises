function is_audio_tagged = IsAudioTagged(audio_path, tagged_data_table)
is_audio_tagged = any(contains(tagged_data_table.key, audio_path));
end