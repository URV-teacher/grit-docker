# grit-docker
grit (GBA Raster Image Transmogrifier) in Docker, to convert images into data for the GBA / NDS. It is the grit of the
devkitARM r46 release used by the course.

```shell
docker run --rm -v "$PWD:/input" aleixmt/grit image.png -gB8 -gTFF00FF -o image
```

## Build and installation
`scripts/install_grit.sh` installs grit into `/URV/bmde/grit`, with its environment (`PATH`) in
`/etc/profile.d/bmde-grit.sh`. The image is built with it, and it installs grit in an Ubuntu / Debian host too. Test
the installation with `scripts/test_grit.sh`, which converts a PNG that it generates. To build the image:

```shell
docker build -t aleixmt/grit .
```
