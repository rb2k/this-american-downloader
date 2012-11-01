require 'net/http'

episode_list = Net::HTTP.get('www.thisamericanlife.org', '/radio-archives')
current_episode_nr = episode_list[/(\d{3}):/, 1].to_i

1.upto(current_episode_nr) do |number|

  info_path = "/radio_episode.php?episode=#{number}"
  title = 'n_a'
  Net::HTTP.start('www.thisamericanlife.org', 80) do |http|
    response = http.request_head(info_path)
    title = response['Location'].to_s.split('/').last
  end
  file_name = "#{"%03d" % number}_#{title}.mp3"
  if File.exist?(file_name)
    puts "Skipping: #{file_name}"
  else
    puts "Downloading: #{file_name}"
    url = "http://audio.thisamericanlife.org/jomamashouse/ismymamashouse/#{number}.mp3"
    `curl #{url} -o #{file_name}`
  end
end
