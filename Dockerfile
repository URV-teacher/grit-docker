# grit, to convert images into data for the GBA / NDS. The installation is done by the scripts in src/ (with the assets
# downloaded into assets/ by scripts/download_assets.sh), the same ones used to install it in a host (see README.md).
# Base image of the BMDE images (docker-bake.hcl of bmde replaces this stage by the base image being built)
FROM aleixmt/bmde-base:latest AS bmde-base

FROM bmde-base

RUN --mount=type=bind,target=/component \
    /component/src/install_grit.sh \
    && rm -rf /var/lib/apt/lists/*

# Directory where the images to convert are mounted
RUN mkdir -p /input
WORKDIR /input

ENTRYPOINT ["bmde-exec", "grit"]
CMD []
