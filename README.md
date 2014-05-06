# TaskReporter  [![Build Status](https://secure.travis-ci.org/caifara/task_reporter.png)](http://travis-ci.org/caifara/task_reporter)

## Ruby version

Version 0.3.2 works with Ruby 1.8.7, from there on only Ruby >= 1.9.3 is supported.

## Installation

Add this line to your application's Gemfile:

    gem 'task_reporter', "0.3.3", :git => "git://github.com/by2-be/task_reporter.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install task_reporter

## Configuration

1. You will need to add twitter configuration in `config/initializers/twitter.rb`.

    ```ruby
    Twitter.configure do |config|
      config.consumer_key       = YOUR_CONSUMER_KEY
      config.consumer_secret    = YOUR_CONSUMER_SECRET
      config.oauth_token        = YOUR_OAUTH_TOKEN
      config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
    end
    ```

2. You need to add a some info about your app in `config/initializers/task_reporter.rb`

    ```ruby
    TaskReporter.configure do |c|
      c.customer = "customer name"
      c.project  = "project name"
    end
    ```

## Usage

Tasks may themselves handle error handling in more ways. For example some 
models will send mails with backtraces. That's why you can call task.error 
instead of waiting for a task to error out.

```ruby
TaskReporter.task("name") do |task|
  # call task.success or task.error
  # if nothing gets called, task.success is auto-called

  # if an error is raised, task.error is auto-called
  # a message(string) may be given to these methods

  # if no error was raised, task.success is auto-called
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
