require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get instagram info" do
    post :searchTag, {'tag' => 'cat', 'access_token' => '2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402'}
    assert_response :success
  end

  test "should return json from instagram URL" do
    controller = HomeController.new
    uri = 'https://api.instagram.com/v1/tags/fsdgsdfdssd'
    access_token = "2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402"

    result_data = {"meta"=> {"code"=> 200}, "data"=> {"media_count"=> 0, "name"=> "fsdgsdfdssd"}}
    assert_equal(result_data, controller.get(uri, access_token))
  end

  test "should return highest quality image" do
    controller = HomeController.new
    result_data = "http://www.google.com"
    test_images_list = {
      "low_resolution" => {
        "url" => "https://scontent.cdninstagram.com/t51.2885-15/s320x320/e35/13151281_126562917750025_2134663288_n.jpg?ig_cache_key=MTI0OTUwNDk2MTU2MzEzNzQ5NQ%3D%3D.2",
        "width" => 320,
        "height" => 320
      },
      "thumbnail" => {
        "url" => "https://scontent.cdninstagram.com/t51.2885-15/s150x150/e35/13151281_126562917750025_2134663288_n.jpg?ig_cache_key=MTI0OTUwNDk2MTU2MzEzNzQ5NQ%3D%3D.2",
        "width" => 150,
        "height" => 150
      },
      "standard_resolution" => {
        "url" => "http://www.google.com",
        "width" => 640,
        "height" => 640
      }
    }
    assert_equal(result_data, controller.getHighestQualityUrl(test_images_list))
  end

  test "should format json correctly" do
    controller = HomeController.new
    result_data = {'metadata' => {'total' => 1}, 'version' => ENV['version'],
      'posts' => [
        'tags' => ['cat', 'dog', 'fight'],
        'username' => 'Bob',
        'likes' => 10,
        'url' => 'http://www.google.com',
        'caption' => 'Cat Dog Fight #Sexy',
      ]
    }
    test_tag_metadata = {'meta' => {'code' => 200},'data' => {'media_count' => 1, 'name' => 'cat'}}
    # Test data taken from Instagram API response
    test_tag_recent_posts = {"pagination" => {
      "next_max_tag_id"=> "AQDjkj8rsX9XNRvBox5-883VJHltMPaPw6An7sgMdfOvuO3IJpJCJxdsOT0Q3LhIXweMeoszfQxV6iukNaW_YRbSiUXeIaSK9Jdx5f39vBdZRBlmKkAY_9NVpM6RgHucanM",
      "deprecation_warning"=> "next_max_id and min_id are deprecated for this endpoint; use min_tag_id and max_tag_id instead",
      "next_max_id"=> "AQDjkj8rsX9XNRvBox5-883VJHltMPaPw6An7sgMdfOvuO3IJpJCJxdsOT0Q3LhIXweMeoszfQxV6iukNaW_YRbSiUXeIaSK9Jdx5f39vBdZRBlmKkAY_9NVpM6RgHucanM",
      "next_min_id"=> "AQA3aKgugWd5NtGgLijOdeGkq2FLP-3M3E_9nhu3m198Or5iSN6lzGaiu3Sl0FIe5HurdD76-qZXdW13LbxBruxCR1uW_FRqMcnhhGnb08rYXITHBKyL7pBwP9QS1Ex4Mdw",
      "min_tag_id"=> "AQA3aKgugWd5NtGgLijOdeGkq2FLP-3M3E_9nhu3m198Or5iSN6lzGaiu3Sl0FIe5HurdD76-qZXdW13LbxBruxCR1uW_FRqMcnhhGnb08rYXITHBKyL7pBwP9QS1Ex4Mdw",
      "next_url"=> "https://api.instagram.com/v1/tags/cat/media/recent?access_token=2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402&max_tag_id=AQDjkj8rsX9XNRvBox5-883VJHltMPaPw6An7sgMdfOvuO3IJpJCJxdsOT0Q3LhIXweMeoszfQxV6iukNaW_YRbSiUXeIaSK9Jdx5f39vBdZRBlmKkAY_9NVpM6RgHucanM"
    },
    "meta" => {"code" => 200},
    "data" => [
      {
        "attribution" => nil,
        "tags" => ["cat", "dog", "fight"],
        "type"=> "image",
        "location" => nil,
        "comments" => {
          "count" => 0,
          "data" => []
        },
        "filter" => "Amaro",
        "created_time" => "1463172620",
        "link" => "https://www.instagram.com/p/BFXIiRzDxXX/",
        "likes" => {
          "count" => 10,
          "data" => []
        },
        "images" => {
          "low_resolution" => {
            "url" => "https://scontent.cdninstagram.com/t51.2885-15/s320x320/e35/13151281_126562917750025_2134663288_n.jpg?ig_cache_key=MTI0OTUwNDk2MTU2MzEzNzQ5NQ%3D%3D.2",
            "width" => 320,
            "height" => 320
          },
          "thumbnail" => {
            "url" => "https://scontent.cdninstagram.com/t51.2885-15/s150x150/e35/13151281_126562917750025_2134663288_n.jpg?ig_cache_key=MTI0OTUwNDk2MTU2MzEzNzQ5NQ%3D%3D.2",
            "width" => 150,
            "height" => 150
          },
          "standard_resolution" => {
            "url" => "http://www.google.com",
            "width" => 640,
            "height" => 640
          }
        },
        "users_in_photo" => [],
        "caption" => {
          "created_time" => "1463172620",
          "text" => "Cat Dog Fight #Sexy",
          "from" => {
            "username" => "gokucatlife",
            "profile_picture" => "https://igcdn-photos-b-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-19/s150x150/13108748_234371036932953_2054202104_a.jpg",
            "id" => "3236295964",
            "full_name" => "Goku Cat Life"
          },
          "id" => "17857213309056042"
        },
        "user_has_liked" => false,
        "id" => "1249504961563137495_3236295964",
        "user" => {
          "username" => "Bob",
          "profile_picture" => "https://igcdn-photos-b-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-19/s150x150/13108748_234371036932953_2054202104_a.jpg",
          "id" => "3236295964",
          "full_name" => "Goku Cat Life"
        }
      }]
    }
    assert_equal(result_data, controller.formatResponse(test_tag_metadata, test_tag_recent_posts))
  end
end


