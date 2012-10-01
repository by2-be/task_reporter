# TaskReporter

## Installation

Add this line to your application's Gemfile:

    gem 'task_reporter', :git => "git@github.com:by2-be/task_reporter.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install task_reporter

## Configuration

You need to add twitter configuration.

    Twitter.configure do |config|
      config.consumer_key = YOUR_CONSUMER_KEY
      config.consumer_secret = YOUR_CONSUMER_SECRET
      config.oauth_token = YOUR_OAUTH_TOKEN
      config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
    end

## Usage

    TaskReporter.task("name") do |task|
      # call task.success or task.error
      # if nothing gets called, task.success is auto-called
      # if an error is raised, task.error is auto-called
      # a message(string) may be given to these methods
    end

Tasks may themselves handle error handling in more ways. For example some 
models will send mails with backtraces. That's why you need to call task.error.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
