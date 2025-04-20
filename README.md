# MusicAgent

A Ruby CLI application that schedules and plays music at specific times.

## Features

- Play music immediately (including random Bollywood songs)
- Schedule music to play at a specific time
- Schedule music to play after a specific duration
- Search for songs in the feel-good Bollywood songs list
- List all available feel-good Bollywood songs
- List scheduled songs
- Cancel scheduled songs

## Requirements

- Ruby 2.6 or higher
- spotdl (for downloading songs from Spotify)
- An audio player (mpv, mplayer, vlc, or afplay on macOS)

## Installation

1. Clone this repository
2. Install dependencies:

```bash
gem install bundler
bundle install
```

3. Install spotdl:

```bash
# Using pip
pip install spotdl

# For more installation options, see: https://github.com/spotDL/spotify-downloader
```

4. Make the script executable:

```bash
chmod +x musicagent.rb
```

## Usage

### Play a song immediately

```bash
# Play a specific song
ruby musicagent.rb play "Tum Se Hi - Jab We Met"

# Play a random Bollywood song
ruby musicagent.rb play
# or
ruby musicagent.rb random
```

### List all available songs

```bash
ruby musicagent.rb list_songs
```

### Search for songs

```bash
ruby musicagent.rb search "Jab We Met"
```

### Schedule a song to play at a specific time

```bash
# Play a specific song at a specific time
ruby musicagent.rb at "Tum Se Hi - Jab We Met" "08:00"

# Play a random Bollywood song at a specific time
ruby musicagent.rb at "08:00"
```

### Schedule a song to play after a duration

```bash
# Play a specific song after a duration
ruby musicagent.rb in "Tum Se Hi - Jab We Met" "30m"

# Play a random Bollywood song after a duration
ruby musicagent.rb in "30m"
```

### List scheduled songs

```bash
ruby musicagent.rb list
```

### Cancel a scheduled song

```bash
ruby musicagent.rb cancel JOB_ID
```

## How It Works

This application uses:

1. **spotdl** to download songs from Spotify
2. **mpv/mplayer/vlc** to play the downloaded audio files
3. **rufus-scheduler** to schedule playback at specific times

If downloading fails, the application will use a fallback sample audio file.

## License

MIT
