require 'test_helper'

class VideosAPITest < ActionDispatch::IntegrationTest
    setup do
        host! 'api.grandstand.com'
    end

    test 'returns a list of videos' do
        get '/videos'

        assert_equal 200, response.status

        server_response = json(response.body)

        assert_equal 2, server_response[:videos].length
    end

    test 'return a specific video' do
        video = Video.first

        get "/videos/#{video.id}"

        assert_equal 200, response.status

        server_response = json(response.body)

        assert_equal video.url, server_response[:video][:url]
    end

    test 'create new video' do
        post '/videos',
             { video:
                {
                    url: "http://www.test.com/videourl",
                    description: "This is a description"
                }
             }.to_json,
             { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

        assert_equal 201, response.status
        assert_equal Mime::JSON, response.content_type

        video = json(response.body)[:video]
        assert_equal api_video_url(video[:id]), response.location

    end
end