# Contributing to TeSS

While TeSS was originally developed to serve as the training portal for [ELIXIR](https://www.elixir-europe.org/), it endeavours to be a generic platform that can be easily customized and re-used in other communities.

There are numerous ways you can contribute to TeSS.

## Bug reports and suggestions

We welcome anyone to submit bug reports and make feature suggestions on our [GitHub issues page](https://github.com/ElixirTeSS/TeSS/issues).

## Documentation

TeSS has various levels of documentation that can be contributed to:

* [Technical documentation](https://github.com/ElixirTeSS/TeSS/tree/master/docs) - Mostly related to how to install and configure TeSS (Markdown)
* [API documentation](https://github.com/ElixirTeSS/TeSS/tree/master/public/api/definitions) - Specifications on how TeSS' APIs function, with some descriptions and guidance (Swagger 2.0 YAML)
* User documentation - *Help wanted!* - Guidance for users of TeSS on best practices, how they can automatically register resources, etc. (Markdown?)

Small changes can be made directly in GitHub, just open the relevant file, click the pencil icon, make your change, and click the "Proprose changes" button.

For larger contributions, see the section below.

## Code

### Fork TeSS

Create a fork of [TeSS on Github](https://github.com/ElixirTeSS/TeSS) and check out your copy.

```
git clone https://github.com/<your account>/TeSS.git
cd TeSS
git remote add upstream https://github.com/ElixirTeSS/TeSS.git
```

### Create a feature branch

Decide which branch do base your feature branch off. This will probably be `master` unless you are contributing a bug fix to a release of TeSS, in which case use e.g. `tess-1.2`.

Make sure your fork is up-to-date with upstream TeSS.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

### Set up TeSS

Follow our [installation guide](https://github.com/ElixirTeSS/TeSS/blob/master/docs/install.md) to set up your local instance of TeSS.

### Run tests

TeSS has an extensive test suite and aims to have as close to 100% test coverage as possible. Ensure you can run the existing test suite.

```
bundle exec rails test
```

### Write code!

#### Code style

TeSS tries to follow the [Ruby Style Guide](https://github.com/rubocop/ruby-style-guide). We also make use of [rubocop](https://github.com/rubocop/rubocop). 

Your IDE may have rubocop integration, but if not, you can run it manually:

```
rubocop lib/my_code_that_i_wrote.rb
```

or to automatically apply fixes:

```
rubocop -a lib/my_code_that_i_wrote.rb
```

#### Testing

Ensure your code is completely covered by test cases. Read through some existing tests to get an idea of how your code could be tested.

Run the test suite to check your change has not broken any existing code. You can also see the test coverage % after the tests finish, make sure it has not decreased.

```
bundle exec rails test
```

### Commit meaningfully

Make sure your commits contain meaningful and related changes, and a commit message describing the change.

If you fix something unrelated to the rest of your changes, e.g. you found a typo somewhere, try and do it in a separate commit.

If your commit is related to an issue, tag the issue using e.g. `#123` in the commit message.

You can always [rebase](https://docs.github.com/en/get-started/using-git/about-git-rebase) any rough commits later on to make them easier to follow.

### Open a Pull Request

Go to your fork of TeSS on GitHub and select your feature branch. Click the 'Pull Request' button and fill out the form.

Your Pull Request should trigger a build that can be monitored on our [actions](https://github.com/ElixirTeSS/TeSS/actions) page.

Check in from time to time, or wait for notifications of any reviewer comments or build failures.

If you need to make additional code changes, just push them to your original branch and GitHub will update the open Pull Request.

### Thanks!

