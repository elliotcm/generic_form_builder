Important!  This gem has long gone stagnant and is not actively maintained.  Use at your own risk!

# Generic form builder

You like, use it.  And stuff.

Instead of the normal one.

I dunno shut up go away stop asking questions.

## Subclassing

This is a "generic" form builder because it covers most cases and is a starting point for domain specific form needs.

If there's something missing that you think might be relevant to the wider world by all means put in a pull request,
otherwise subclass the generic builder with your own domain specific additions.

## XSS WARNING

In order to facilitate fancier notes and inline errors, all output from these helpers are considered HTML safe and will not be escaped.

DO NOT send any user input of any kind into the extra options (`note`, `label` etc) or you will be at risk of various attacks.
