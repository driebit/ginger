Browser tests
=============

Ginger ships with an automated end-to-end browser testing setup, batteries 
included. The tests are written in [Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin),
executed by [Nightwatch.js](http://nightwatchjs.org) and run against a 
Selenium-based headless Chrome instance. 

The setup consists of:

- a `selenium` Docker container with a headless Chrome, so you can run the tests
  in a CI environment as well
- a `node-tests` container that contains Nightwatch.js and its WebDriver client 
  and executes the JavaScript
- a Nightwatch.js configuration
- [Cucumber.js](https://github.com/cucumber/cucumber-js) 
  [step definitions](../../tests/features/step_definitions/) geared towards 
  Ginger sites. 
 
Writing browser site tests
--------------------------

In your Ginger site, add a `features/` directory. In this directory, add
`.feature` files to describe your site’s behaviour. For instance:

```gherkin
# yoursite/features/homepage.feature
Feature: homepage

Scenario: homepage title

    When I visit "/"
    Then the title is "Welcome to my website!"
```

For more information, consult Ginger’s [step definitions](../../tests/features/step_definitions/)
and the [Cucumber.js docs](https://github.com/cucumber/cucumber-js).

Running your tests
------------------

### Run in Docker

To run your tests:

```bash
$ make test site=yoursite
```

When a test fails, a screenshot is automatically made and stored in 
`tests/screenshots`.

### Run locally

To run the tests on a local Chrome instance, so you can see what is happening:

```bash
$ make test-chrome site=yoursite
```

### Pass arguments to Nightwatch

For instance, to execute only tests tagged `@wip`:

```bash
$ make test site=yoursite args=--tag=wip
```

IDE integration
---------------

* In [IntelliJ IDE](https://www.jetbrains.com/idea/), including WebStorm,
  [install](https://www.jetbrains.com/help/idea/2017.1/preparing-to-use-cucumber-js-test-runner.html)
  the [Cucumber.js plugin](https://plugins.jetbrains.com/plugin/7418-cucumber-js).
  WebStorm comes bundled with Gherkin support; in IntelliJ you can install the
  [Gherkin plugin](https://plugins.jetbrains.com/plugin/7211-gherkin).
