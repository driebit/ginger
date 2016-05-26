Why Ginger is a single Git repository
=====================================

Instead of storing each Ginger module in its own Git repository, we combine them
in one monolith repository. With this, we’re following the monolith or monorepo
strategy advocated by [Facebook](https://www.facebook.com/FacebookforDevelopers/videos/10152800517193553/),
[Google](https://www.youtube.com/watch?v=W71BTkUbdqE),
[Symfony](https://events.drupal.org/neworleans2016/sessions/symfony-monolith-repository)
and others.

In the case of Ginger, there are at least 3 distinctive benefits of having
a single repository:

1. There’s **less maintenance overhead**: every developer and all environments
   will always have the same version of all modules. This is true especially

2. **Releasing is easier**: because we’re constantly testing the modules
   together, we’ll quickly notice whether any incompatibilities between
   modules occur.

3. To the outside world, Ginger is one product. Having one repository means
   there’s **one place** that users can report issues and developers can open
   pull requests.

Read-only splits
----------------

Of course, it should still be possible to include a single Ginger module
in a Zotonic project. To enable this, we will create
[read-only subtree splits](https://github.com/driebit/ginger/issues/55) and keep
those updated automatically whenever a commit is pushed to the main repository.
