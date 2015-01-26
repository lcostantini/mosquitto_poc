require 'dotenv'

Dotenv.load

Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = "html"

CLIENT = Mosca::Client.new

Cuba.define do
  on get do
    on root do
      res.write partial("index")
    end
  end

  on post do
    on "publish/:topic/:payload" do |topic, payload|
      begin
        CLIENT.publish! payload, topic_out: topic
        res.write "Public the value '#{payload}' in channel '#{topic}'"
      rescue Timeout::Error
        res.write "Connection timed out. Couldn't publish on broker"
      rescue Exception => e
        res.write "ERROR: #{e.message}"
      end
    end
  end
end
