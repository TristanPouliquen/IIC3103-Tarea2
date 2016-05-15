require 'net/http'
require 'json'

class HomeController < ApplicationController
  def index
  end

  def searchTag
    tag = params.has_key?(:tag) ? params[:tag] : nil
    access_token = params.has_key?(:access_token) ? params[:access_token] : nil

    if tag.nil? or access_token.nil?
      render json: {'error' => 'Missing parameter'}, root: false, status: :bad_request
    else
      tag_metadata = get('https://api.instagram.com/v1/tags/' + tag, access_token)
      tag_recent_posts = get('https://api.instagram.com/v1/tags/' + tag + '/media/recent', access_token)

      result = formatResponse(tag_metadata, tag_recent_posts)
      render json: result, root: false
    end
  end

  def get(uri, access_token)
    uri = URI.parse(uri + '?access_token=' + access_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    return JSON.parse(response.body)
  rescue JSON::ParserError
    return {}
  end

  def formatResponse(tag_metadata, tag_recent_posts)
    result= { 'metadata' => {},
              'version' => ENV['version'],
              'posts' => []
            }

    count = tag_metadata['data']['media_count']
    result['metadata'] = {'total' => count}

    tag_recent_posts['data'].each do |post|
      tags = post.has_key?('tags') ? post['tags'] : []
      username = (post.has_key?('user') and post['user'].has_key?('username')) ? post['user']['username'] : ''
      likes = (post.has_key?('likes') and post['likes'].has_key?('count')) ? post['likes']['count'] : 0
      caption = (post.has_key?('caption') and post['caption'].has_key?('text')) ? post['caption']['text'] : ''

      result['posts'] << {
        'tags' => tags,
        'username' => username,
        'likes' => likes,
        'url' => getHighestQualityUrl(post['images']),
        'caption' => caption
      }
    end

    return result
  end

  def getHighestQualityUrl(images)
    resolution = images.has_key?('standard_resolution') ? 'standard_resolution' : 'low_resolution'
    return images[resolution]['url']
  end
end
