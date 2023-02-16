package com.example.recyclerview_example;

import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

/**
 * Provide a reference to the type of views that you are using
 * (custom ViewHolder).
 */
public class CustomViewHolder extends RecyclerView.ViewHolder {

    private final TextView textView;
    private final LinearLayout audioLayout;
    private final ImageButton playButton;

    public CustomViewHolder(View view) {
        super(view);
        // Define click listener for the ViewHolder's View

        textView = view.findViewById(R.id.textView);
        audioLayout = view.findViewById(R.id.audio_layout);
        playButton = view.findViewById(R.id.play_button);
    }

    public TextView getTextView() {
        return textView;
    }

    public LinearLayout getLayout() {
        return audioLayout;
    }

    public ImageButton getPlayButton() {return playButton;}

}
