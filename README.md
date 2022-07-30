![Bash](https://img.shields.io/badge/bash-5.0.17(1)-blue)
![Perl](https://img.shields.io/badge/perl-v5.30.0-9cf)
![Perl](https://img.shields.io/badge/ubuntu-20.04-purple)

# Scriptit

Cookie-cutter for autogenerating bash scripts. Writes the boilerplate so *scripters* can focus on the meat and potatos.

![scriptit in action](./assets/scriptit.gif)

**The template includes ...**
- [unofficial bash strict mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- script dir env var
- git env var
- colored output
- arg parsing
- etc

## 🚀 Getting Started

Follow the series of prompts after cloning and calling `script.sh`. 

### 💥 Barebones script - from source

```
git clone git@github.com:onescriptkid/scriptit && pushd scriptit > /dev/null
./scriptit.sh -s -a0 barebones.sh
...
Created script:

        ~/onescriptkid/scriptit/barebones.sh
```

### 💥 Script with prompts - from source

```shell
git clone git@github.com:onescriptkid/scriptit && pushd scriptit > /dev/null
./scriptit.sh -s script_that_requires_argparsing.sh
...
Created script:

        ~/onescriptkid/scriptit/script_that_requires_argparsing.sh
```
### 🐳 Barebones script - from docker
```shell
docker run -v /tmp:/tmp -it onescriptkid/scriptit -s -a0
...
Created script:

        /tmp/scriptit-XXXXoGjHjL/scriptit_script.sh
```
### 🐳 Script with prompts - from docker

```shell
docker run -v /tmp:/tmp -it onescriptkid/scriptit
...
Created script:

        /tmp/scriptit-XXXXoGjHjL/scriptit_script.sh
```

## 🌲 Dependencies

Older versions of **Bash 4.X / 3.X** and Perl should work, but are untested

 - Bash `5.0.17(1)`
 - Ubuntu `20.04`
 - *Yaml Parser requires*
   - sed `(GNU sed) 4.7`
   - mawk `1.3.4 20200120`

Ubuntu should already have these deps, but if they're missing
```
sudo apt update && sudo apt install perl bash sed mawk -y
```

## ⚙️ For devs,
### To test locally,

`test_*` prefix unit tests. To test, run 

*Example unit test for SCRIPT_DIR*
```
./test/test_bash_script_dir.sh

...
test_absolute /tmp/scriptit-XXX/script.sh
REALPATH   is: /tmp/scriptit-NS1SFLpaz7
SCRIPT_DIR is: /tmp/scriptit-NS1SFLpaz7

test_symlink_relative
REALPATH   is: /tmp/scriptit-NS1SFLpaz7
SCRIPT_DIR is: /tmp/scriptit-NS1SFLpaz7

test_space_in_pathname /abc/d ef/hi/script.sh
REALPATH   is: /tmp/scriptit-NS1SFLpaz7/abc/d ef/hij
SCRIPT_DIR is: /tmp/scriptit-NS1SFLpaz7/abc/d ef/hij

```

## 😇 For Maintainers,

### To cut a new version,

List the top tag `vX.X.X`

```
git describe --tags --abbrev=0 --match "v[0-9]*"
```

Push a new tag `vX.X.X+1`
```
git tag -a "v1.0.2" -m "Release v1.0.2"
git push --tags
```
### To build the docker image

`./deploy/build.sh` adds the repo contents to the Dockerfile and adds tags.

```
./deploy/build.sh
...
Step 12/12 : CMD [ /scriptit/scriptit.sh ]
 ---> Running in 145cfe78d5c4
Removing intermediate container 145cfe78d5c4
 ---> 6f7d5a86a88e
Successfully built 6f7d5a86a88e
Successfully tagged scriptit:latest
```

### To push a new docker image to dockerhub,

Login with `docker login -u onescriptkid`

`./deploy/push` pushes the `scriptit` dockerimage to dockerhub

```
./deploy/push.sh
...
dc62e246cb08: Layer already exists 
a8df7183ce0b: Layer already exists 
1ad27bdd166b: Layer already exists 
v0.0.1-1-g557e9e0: digest: sha256:aa52c11054c87c939a24e5d62e974dfa4551ad4ed5d898fd4a19b5d8ee7d4ade size: 2401
```