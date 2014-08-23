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

EXAMPLE

	[you@server.com] domlogs >> ./find_spiders.pl yourwebsite.example.com
	Working on yourwebsite.example.com

	------------------
	Top Hitters Report
	------------------
	Hits,Approved,TLD,Host,IP,UA
	67688,0,msn.com,msnbot-123-123-123-123.search.msn.com,123.123.123.123,Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)
	65867,0,msn.com,msnbot-123-123-123-123.search.msn.com,123.123.123.123,Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)
	...
	16881,0,No TLD,No host found,123.123.123.123,Twitterbot/1.0
	...
	13963,0,softlayer.com,123.123.123.123-static.reverse.softlayer.com,123.123.123.123,ShowyouBot (http://showyou.com/crawler)
	...
	6515,0,googlebot.com,crawl-123-123-123-123.googlebot.com,123.123.123.123,Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
	6323,0,googlebot.com,crawl-123-123-123-123.googlebot.com,123.123.123.123,Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
	6285,0,amazonaws.com,ec123-123-123-123-101.us-west-1.compute.amazonaws.com,123.123.123.123,Google-HTTP-Java-Client/1.17.0-rc (gzip)
	...

	---------------
	Major TLD Report
	----------------
	Hits,TLD
	401344,msn.com,123.123.123.123,Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)
	168826,googlebot.com,123.123.123.123,Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)
	84153,No TLD,123.123.123.123,Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0
	61185,softlayer.com,123.123.123.123,AddThis.com robot tech.support@clearspring.com
	45248,amazonaws.com,123.123.123.123,Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.123.123.123 Safari/537.36
	24206,topsy.com,123.123.123.123,Mozilla/5.0 ()
	23338,clearspring.com,123.123.123.123,AddThis.com robot tech.support@clearspring.com
	18142,yahoo.net,123.123.123.123,Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)
	16937,twttr.com,123.123.123.123,Twitterbot/1.0
	16582,your-server.de,123.123.123.123,Mozilla/5.0 (compatible; uMBot-LN/1.0; mailto: crawling@ubermetrics-technologies.com)
	15010,qwest.net,123.123.123.123,Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Firefox/31.0
	10468,comcast.net,123.123.123.123,Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0
	5347,123-123-123-123-customer-incero.com,123.123.123.123,MetaURI API/2.0 +metauri.com
	----------------

LICENSE
       GPL v2 https://www.gnu.org/licenses/gpl-2.0.html

AUTHOR
       Bryan Gmyrek <bryangmyrek@gmail.com>
