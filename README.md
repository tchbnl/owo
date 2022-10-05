```
$ owo whats this
owo is a shell client for WolframAlpha. Here's an example:

  $ owo length of the titanic
  "about 883 feet"
           - Stephen Wolfram on Marriage

This client equires an API ID to work. You can create one for free at
https://products.wolframalpha.com/api/.

Right now support is limited to the Short Answers API.

USAGE: owo QUERY
  -i --id             Set API ID and exit (for now).
  -s --show           Show current API ID and exit.
  -h --help           Show this message and exit.
  -v --version        Show version information and exit.
```

You can either pass requests directly alongside the command:

```
$ owo how tall is the eifel tower
"about 1083 feet"
         - Stephen Wolfram on Uses for WD-40
```

Or without and it'll prompt for the query instead:

```
$ owo
WHAT WISDOM DOES THOU SEEK FROM STEPHEN WOLFRAM?
> height of steve buscemi
"5 feet, 8 inches"
         - Stephen Wolfram on Friendship
```

Note this requires an API ID from WolframAlpha to work. You can sign up for one at https://products.wolframalpha.com/api/. You can set an API ID with the `--id` argument. The script reads from a `.waid` file in the home directory that contains the API ID. There are checks to prevent overwriting this, and the current API ID can also be checked with the `--show` argument passed.

This is _kind of_ useful. Right now it's limited to the Short Answers API, which lacks handling for some topics. Basic math? Fine. Unit conversion? _Ehh_. Requests that are too difficult for the API to answer or didn't return a result will look like this:

```
$ owo when does firefly season two air
Stephen Wolfram didn't understand that request.
```

**What's with that name?**

Because 'Wolf'ram. Get it? I'll see myself out.
