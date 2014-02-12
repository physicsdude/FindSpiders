FindSpiders
===========

NAME
       find_spiders.pl - A script to find spiders from apache web logs and
       report on them.

DESCRIPTION
       This is old code but has tended to work like a charm for me.  You can
       put this in a cron and get daily emails about who's hammering your
       site.  It's also helpful for forensic analysis after some jerk crawler
       takes your server down.  One nice feature is that it does hostname
       lookups on the bots IPs (once-per-ip), so it's easier to tell if it's a
       bot that's actually from google or another legit search engine.

USAGE
   EXAMPLE
       Analyze and report on the last 1000 lines of your domain's apache log.

       ./find_spiders.pl -f /home/domlogs/YOURDOMAIN.com  -l 1000

LICENSE
       GPL v2 https://www.gnu.org/licenses/gpl-2.0.html

AUTHOR
       Bryan Gmyrek <bryangmyrek@gmail.com>