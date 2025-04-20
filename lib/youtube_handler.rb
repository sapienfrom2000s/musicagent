require 'json'

class YouTubeHandler
  def initialize
    # Nothing to initialize
  end

  def search(query, max_results = 5)
    begin
      puts "Searching YouTube with yt-dlp..."
      # Use yt-dlp to search for videos
      cmd = "yt-dlp --flat-playlist --dump-json --max-downloads #{max_results} \"ytsearch#{max_results}:#{query}\""

      output = `#{cmd}`
      results = []

      output.each_line do |line|
        begin
          video_info = JSON.parse(line)
          results << {
            id: video_info['id'],
            title: video_info['title'],
            channel: video_info['channel'] || video_info['uploader'],
            url: video_info['webpage_url'] || "https://www.youtube.com/watch?v=#{video_info['id']}"
          }
        rescue JSON::ParserError
          # Skip invalid JSON lines
        end
      end

      results
    rescue => e
      puts "Error searching YouTube with yt-dlp: #{e.message}".red
      []
    end
  end

  def download_audio(video_url, output_dir = 'downloads')
    begin
      # Ensure the downloads directory exists
      Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

      # Generate a unique filename
      output_file = "#{output_dir}/%(title)s-%(id)s.%(ext)s"

      # Use yt-dlp to download the audio
      # -x: Extract audio
      # --audio-format mp3: Convert to mp3
      # -o: Output filename template
      cmd = "yt-dlp -x --audio-format mp3 -o \"#{output_file}\" \"#{video_url}\""

      puts "Downloading audio from YouTube..."
      result = system(cmd)

      # Find the downloaded file
      downloaded_file = Dir.glob("#{output_dir}/*.mp3").max_by { |f| File.mtime(f) }

      if result && downloaded_file && File.exist?(downloaded_file)
        puts "Download complete: #{downloaded_file}"
        return downloaded_file
      else
        puts "Failed to download audio".red
        return get_fallback_audio(output_dir)
      end
    rescue => e
      puts "Error downloading audio: #{e.message}".red
      get_fallback_audio(output_dir)
    end
  end

  def download_from_query(query, output_dir = 'downloads')
    puts "Searching and downloading: #{query}"
    results = search(query, 1)

    if results.empty?
      puts "No results found for '#{query}'".red
      return get_fallback_audio(output_dir)
    end

    song = results.first
    puts "Found: #{song[:title]}" + (song[:channel] ? " by #{song[:channel]}" : "")

    # Download the audio
    download_audio(song[:url], output_dir)
  end

  private

  def get_fallback_audio(output_dir = 'downloads')
    puts "Using fallback sample audio file..."
    sample_file = "#{output_dir}/sample_music.mp3"

    # Check if we already have a sample file, if not create a simple one
    unless File.exist?(sample_file)
      # Try to download a known working short audio file
      system("curl -s -L -o #{sample_file} https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
    end

    if File.exist?(sample_file)
      puts "Using sample audio file: #{sample_file}"
      return sample_file
    end

    nil
  end
end
