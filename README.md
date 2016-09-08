A few tools to ease the use of docker locally.

Download & Install with:

	curl -sLO https://raw.github.com/srevenant/docker-tools/master/.get.sh && bash ./.get.sh && rm .get.sh

This will download the tools into ~/.docker-tools/bin and add it to your path.

Using Docker Tools
------------------

Setup in your local repo either a [Reactor Actions](https://github.com/srevenant/reactor) or an env file at:

	.pkg/ENV

Which has:

	export DOCKER_NAME={name of image}
	export DOCKER_IMAGE={org/$DOCKER_NAME}
	export DOCKER_TAGS="{any tags to add to the default build}"
    export DOCKER_ARGS="vars to export as build args"

Additionally you can just define DOCKER_TAGS at build time, and you can include BUILD_VERSION which will include a version as a tag.  If you specify NO_DOCKER_CACHE it will include --no-cache to the build.

Commands:

* __docker-build__ -- make a build using the current repo.  Dockerfile may be in current folder or in .pkg/Dockerfile.  Includes any variables on DOCKER_ARGS as --build-args
* __docker-clean__ -- clean ALL images -- very destructive, use with care
* __docker-images__ -- list all running containers matching the current repo, and all images
* __docker-push__ -- push to docker
* __docker-run__ -- run a docker container based on current repo.  Will terminate any currently running containers.  May override default run behavior with .pkg/docker-run file that is the alternate docker run command and args, with variables to be evaluated (i.e. $DOCKER_IMAGE)
* __docker-build-run__ -- do a docker-build, followed immediately by a docker-run
* __docker-shell__ -- pull up a shell on the current image

