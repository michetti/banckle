# Banckle

This is a very initial implementation of the Banckle Customer Services
2.0 API in Ruby on Rails.

http://banckle.com/

For now, it is only possible to authenticate and to schedule a meeting,
as these are the only things I need.


## Installation

Add this line to your application's Gemfile:

    gem 'banckle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install banckle

## Usage

First, create the api object:
```api = Banckle::API.new(<userid>, <password>)```

Authenticate:
```token = api.authenticate(<product>)```

And schedule meeting rooms:
```meeting_id = api.schedule_meeting(<subject>, <start>, <config>)```

There is a helper method to retrieve the meeting url:
```meeting_url = api.meeting_url(<meeting_id>)```


## Testing the Gem

I'm using Rspec, but it ends up interacting with the API itself, so you
need to edit spec/banckle_spec.rb, and set you userid and password.

After doing this, just run: ```rspec spec/banckle_spec.rb```


## Contributing

Fell free to send pull requests.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
