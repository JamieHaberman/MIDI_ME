
class Audio {

  boolean play_track;
  float play_track_time_start;
  float  play_track_length;
  AudioPlayer sample;

  //////audio constructor

  Audio(boolean tempPlay_track, float tempPlay_track_time_start, float tempPlay_track_length, AudioPlayer tempSample) { 
    play_track=tempPlay_track;
    play_track_time_start = tempPlay_track_time_start;
    play_track_length = tempPlay_track_length;
    tempSample= sample;
  }

  //////setter for sample

  void setSample(AudioPlayer thesample) {            
    sample = thesample;
  }

  //////getter for sample

  AudioPlayer getSample() {
    return sample;
  }

  boolean getPlay_track(float area_sum) {
    if (area_sum > 20) {
      play_track_time_start = millis();
      println(area_sum);
      return true;
    } else {
      return false;
    }
  }


  void mixSample(AudioPlayer sample, int index ) {
    fft[index].forward( sample.mix );
  }
  
  void stopTrack() {
    if (millis() - play_track_time_start > play_track_length) {
      sample.rewind();
      sample.mute();
    }
  }
}