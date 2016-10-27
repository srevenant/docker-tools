A few tools to ease the use of docker locally.

Download & Install with:

	curl -fsL https://raw.github.com/srevenant/docker-tools/master/bin/docker-tools-update | bash

This will download the tools into ~/.docker-tools/bin and add it to your path.  *You will need to reload your shell to bring it into your environment.*

Using Docker Tools
------------------


Variables that can exist in the running environment and may be used:

* `DOCKER_TAGS` - a list of variable names pulled from your running environment and sent into --build-arg at build time
* `BUILD_VERSION` - if included, this is also tagged on the image at build/push.  I.e. if `BUILD_VERSION=16.02.11`, then `-t imagename:16.02.11` is added.
* `NO_DOCKER_CACHE` - build adds --no-cache when running
* `DOCKER_NAME` - the name of your image, for build and run
* `DOCKER_IMAGE` - specific to build/push, typically `orgname/$DOCKER_NAME`
* `DOCKER_TAGS` - any other tags to include at build time, like `prod` or similar.

For ease, you can store these in your current folder at `.pkg/ENV`, to give the tools some working knowledge about your container (also supported is a [Reflex Actions](https://reflex.cold.org) file).

Commands
--------

Most commands will print out the actions they are taking, for helpful learning.

* __docker-tools-update__ -- pull latest version
* __docker-build__ -- make a build using the current repo.  Dockerfile may be in current folder or in .pkg/Dockerfile.  Includes any variables on DOCKER_ARGS as --build-args
* __docker-clean__ -- cleans all containers that have run and are now in an exit status, and any container images which are dangling (untagged).
* __docker-clean-aged__ -- cleans all container images which are dangling, and any images over "age" old.  Errors are okay, as it does not force and any dependencies will not be removed.  *requires perl* and will try to install a perl dependency when run (works currently in redhat7/centos7/fedora23+).
* __docker-purge__ -- clean ALL containers and images -- very destructive, use with care
* __docker-images__ -- list all running containers matching the current repo, and all images
* __docker-push__ -- push to docker
* __docker-run__ -- run a docker container based on current repo.  Will terminate any currently running containers.  May override default run behavior with .pkg/docker-run file that is the alternate docker run command and args, with variables to be evaluated (i.e. `$DOCKER_IMAGE`)
* __docker-build-run__ -- do a docker-build, followed immediately by a docker-run
* __docker-shell__ -- pull up a shell on the current image

Advanced Tools
--------------

To support a build environment with ephemeral slaves (such as Jenkins), with systemd and docker-1.12, the following scripts also exist.  The assumption these scripts make is that `/docker` is a shared (nfs) mount point, and docker graph/meta data is stored at `/docker/{job}` unique to each job.

* __docker-adm.sh__ -- meant to be called from a build job, to startup docker for that job. Run as `sudo docker-adm.sh start JOBNAME`, and `sudo docker-adm.sh stop`
* __docker-clean-groupshared-cron__ -- meant to be called from cron, rolls through each of the grouped docker job base folders and runs docker-clean-aged on them.  Deals with concurrency issues as well.

