# Sync Zotonic source from host machine #

When developing Zotonic it can be useful to have a local directory containing the source code that synchronizes to your virtual box machine. This can be achieved by following these steps:

1. Clone the Zotonic repository into a local directory.

```bash
$ git clone git@github.com:zotonic/zotonic.git /my/zotonic/dir
```

2. Set the environment variable ZOTONIC_LOCAL in your shell configuration or launch Vagrant using an extra argument. ZOTONIC_LOCAL should contain the path to your local Zotonic directory. Paths can be relative to your Vagrantfile.

```bash
$ ZOTONIC_LOCAL="/my/zotonic/dir" vagrant up
```

3. SSH to the virtual machine

```bash
$ vagrant ssh
```

4. Stop the Zotonic service

```bash
$ sudo service zotonic stop
```

5. Build Zotonic from source

```bash
cd /opt/zotonic
make
```

6. Start Zotonic and compile custom ginger modules

```bash
$ zotonic debug
(zotonic001@ginger)1> z:m().
```

Your local Zotonic source directory (i.e. /my/zotonic/dir) is now in sync with the /opt/zotonic directory on the virtual machine.
