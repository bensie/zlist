# ZList

ZList is a simple yet powerful mailing list application and is built on Rails. It can
send mail to an unlimited number of recipients, can be configured as announcement only
or it can be fully interactive.  Subscribers can view and reply entirely by email. All
discussions are archived so you can go back anytime to see what was said.

It accepts emails HTTP POSTed to a particular URL. Postmark (postmarkapp.com) is what
we use and is what's officially supported for incoming email.  Postmark is also used
for outgoing SMTP by default.

## Installation

You can get the latest by downloading the master branch from GitHub, or you can grab the
most recent tagged version on the downloads page at http://github.com/bensie/zlist/downloads

## Prerequisites

ZList currently runs on Rails 3.2.0 and requires Ruby 1.9.

Copyright (c) 2012 James Miller and David Hasson
