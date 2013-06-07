# Overview
Quickly hacked together to show DM history.

DMs aren't fully available in any twitter client that I use. So I wrote a thing, since I don't want to give unknown applications access to my direct messages, plus wanted to play with OAuth.

# Usage
1. Create a new application at https://dev.twitter.com/
1. Let it read, write and Access Direct Messages. This application just reads your direct messages, but the permissions model for Twitter isn't fine-grained enough to just allow that.
1. Set the callback URL to `http://127.0.0.1:3000/oauth/callback`
1. `bundle` and then run this app locally using the Consumer Key and Consumer Secret for your application.

```sh
CONSUMER_KEY=app-key CONSUMER_SECRET=app-secret bundle exec rails s -b 127.0.0.1
```

Access http://127.0.0.1:3000/, follow the links and look at your conversations.

# Caveats

Twitter rate-limits the API that this uses. This means that this application is only really intended for a quick view of your direct messages. Using this app frequently in a short period will typically mean you get rate-limited and can't view your DMs with those application credentials for a bit.