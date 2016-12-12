
Storer saves ran-tests visible-files using the new non-git format.
E.g, if the kata-id is F72C61785F and the avatar is lion
and the tag is 17 then the visible-files are stored in
  .../katas/F7/2C61785F/lion/17/manifest.json


However, storer still needs to retrieve data stored in the old git format.
E.g for the example above, the visible-files would be stored in
  git commit tag=17 in the file
  .../katas/F7/2C61785F/lion/manifest.json


In order to test that the new storer correctly retrieves data stored
in the old git-format I need a kata with a known kata-id created in the
old git-format. This dir provides that. Specifically
  .../katas/5A/0F824303/spider

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Note: I got 5A/0F824303/spider out of a live katas data-container using...

   CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
   VOLUME_PATH=/usr/src/cyber-dojo/katas
   docker run -rm --volumes-from ${CONTAINER_NAME} -v $(pwd):/backup \
      cyberdojo/ruby \
      tar cvf /backup/backup.tar ${VOLUME_PATH}
