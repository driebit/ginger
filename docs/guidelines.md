Ginger Guidelines
=================

1. Always check whether a resource is **visible** before displaying it.

    **Building sites**
   
2. When overriding a base/foundation template, use `{% overrules %}` if
   possible. <br>
   Only overwrite the blocks that you really need to overwrite.
   
3. Add JavaScript .js includes in `_script.tpl`.

    **Workflow**

3. Commit bugfixes to the current release branch.

4. Commit new features to the master branch.