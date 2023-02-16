package com.example.recyclerview_example;

import android.util.Log;

import androidx.room.Room;

import java.util.HashMap;
import java.util.List;
import java.util.UUID;

// From https://developer.android.com/training/data-storage/room/

public class AudioCard {

    private String noteId;
    private final String audioDesc;
    private final String address;
    private final String owner;
    private final DatabaseAdapter adapter = DatabaseAdapter.databaseAdapter;
    //private final AppDatabase db;

    // Description, uri, duration, format, owner
    public AudioCard(String description, String localPath, String owner) {
        this.audioDesc = description;
        this.address = localPath;
        this.owner = owner;
        UUID uuid = UUID.randomUUID();
        this.noteId = uuid.toString();
    }
    public String getAddress () {
        return this.address;
    }
    public String getDescription () {
        return this.audioDesc;
    }

    private void setNoteId (String id) {
        this.noteId = id;
    }

    public void saveCard() {

        Log.d("saveCard", "saveCard-> saveDocument");
        adapter.saveDocumentWithFile(this.noteId, this.audioDesc, this.owner, this.address);
    }

    public AudioCard getCard() {
        // ask database and if true, return audioCard
        HashMap<String, String> hm = adapter.getDocuments();
        if (hm != null) {
            AudioCard ac = new AudioCard(hm.get("description"), "", hm.get("owner"));
            ac.setNoteId(hm.get("noteid"));
            return ac;
        } else {
            return null;
        }
    }
}
