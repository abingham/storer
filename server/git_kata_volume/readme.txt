
Storer used to save ran-tests visible-files in a git format. This
created a lot of small files which put unecessary pressure on inodes.

Storer now saves ran-tests visible-files in a non-git format. This
reduces the inode pressure.
E.g, if the kata-id=F72C61785F, avatar=lion, tag=17
then _all_ the visible-files are now stored in
  .../katas/F7/2C61785F/lion/17/manifest.json

Until and unless conversion is done, storer still needs to retrieve
data stored in the old git format.
E.g for the example above, the visible-files would be stored in
  git commit tag=17 in the file
  .../katas/F7/2C61785F/lion/manifest.json

In order to test the storer correctly retrieves data stored in the
old git-format I need a kata with a known kata-id created in the
old git-format. This dir provides that.
Specifically, 5A0F824303.tgz untars to provide /5A/0F824303/spider/.git
Note that I provide the tgz file and untar it into the container.
I do not provide (in the git repo) the already untarred 5A/... dir.
This is because having source with a .git dir in a git repo is problematic.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
I got 5A/0F824303/spider out of a live katas data-container using...

   CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
   VOLUME_PATH=/usr/src/cyber-dojo/katas
   docker run --rm \
     --volumes-from ${CONTAINER_NAME}:ro \
     --volume $(pwd):/backup:rw \
     alpine:latest \
     tar -zcf /backup/backup_5A0F824303.tar -C ${VOLUME_PATH}/5A 0F824303


