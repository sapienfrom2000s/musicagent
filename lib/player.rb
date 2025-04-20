class Player
  def initialize
    # Check if we have a suitable audio player available
    @player_cmd = find_player_command
    raise "No suitable audio player found. Please install mpv, mplayer, or vlc." unless @player_cmd
  end

  def play(audio_file)
    if File.exist?(audio_file)
      puts "Playing: #{audio_file}"
      system("#{@player_cmd} \"#{audio_file}\"")
      true
    else
      puts "Error: Audio file not found: #{audio_file}"
      false
    end
  end

  private

  def find_player_command
    # Try to find a suitable audio player
    players = {
      'mpv' => 'mpv --no-video',
      'mplayer' => 'mplayer -novideo',
      'vlc' => 'cvlc --play-and-exit',
      'afplay' => 'afplay' # macOS
    }

    players.each do |player, cmd|
      return cmd if system("which #{player} > /dev/null 2>&1")
    end

    nil
  end
end
