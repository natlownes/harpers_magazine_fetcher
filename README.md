## Harper's magazine fetcher jawn

Are you a Harper's Magazine subscriber that finds incredible value in being an actual subscriber (not a Zinio et al subscriber where you pay the same amount but can't get at the archives) but wishes that they'd just provide a full pdf on their site to download?  Then maybe this super dirty script, written extremely quickly by a complete stranger is for you.  Many thanks to the author of the PDF::Merger lib.

### Begin

`bundle install`

Use environment variables for everything else.  They are:

`HARPERS_USER` - required, your Harper's username

`HARPERS_PASS` - required, your Harper's password

`HARPERS_ISSUE_DATE` - optional, defaults to current month.  date of the magazine you'd like, in the format of YYYY/mm.  example:  `HARPERS_ISSUE_DATE='2011/11'`

`HARPERS_SAVE_DIRECTORY` - optional, defaults to a series of non-conflicting subdirectories in your /tmp directory

### Example usage

`HARPERS_USER=bonesjones HARPERS_PASS=secretfib HARPERS_ISSUE_DATE="2012/04" ruby bin/harpers_magazine_fetcher`

Into the crontab you go.

### Platforms

Only tried with OSX.

### Disclaimer

Haven't actually read anything this spits out, just finished it 2 minutes ago.  Here's to hoping the PDF file names that look to be sequential are actually sequential.

