GRIT_DIR=/bmde/grit
mkdir -p $GRIT_DIR
wget -O /tmp/grit.tar.bz2 "URL_TO_GRIT_TARBALL"
tar -xf /tmp/grit.tar.bz2 -C $GRIT_DIR
rm /tmp/grit.tar.bz2
echo PATH=$GRIT_DIR:$PATH >> $HOME/.bashrc
