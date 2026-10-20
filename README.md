# grit-docker
grit (GBA Raster Image Transmogrifier) in Docker, to convert images into data for the GBA / NDS. It is the grit of the
devkitARM r46 release used by the course.

```shell
docker run --rm -v "$PWD:/input" aleixmt/grit image.png -gB8 -gTFF00FF -o image
```

## Build and installation
`scripts/download_assets.sh` downloads devkitARM r46 (grit is taken from it) into `assets/`, checking its SHA-256 (see
[external resources](https://github.com/URV-teacher/bmde/blob/master/docs/development/external-resources.md) of bmde).
Then `src/install_grit.sh` installs grit into `/URV/bmde/grit`, with its environment (`PATH`) in
`/etc/profile.d/bmde-grit.sh`, taking the files only from `src/` and `assets/`. The image is built with it, and it
installs grit in an Ubuntu / Debian host too. Test the installation with `test/test_grit.sh`, which converts a PNG that
it generates. To build the image:

```shell
scripts/download_assets.sh  # The image is built from the assets
docker build -t aleixmt/grit .
```
