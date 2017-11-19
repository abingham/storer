
The one_time_creation_of_katas_data_container() happens
inside server/katas_volume/build_data_container.sh
and _not_ inside server/up.sh
This is because of rights.
If it happened inside up.sh then up.sh would have to be
running in a container that contained docker, and would
have to be running as a user with rights to run docker.

The name of the katas-data-container is the same name as
used by commander. This allows a server running all the
cyber-dojo services to switch to being a server just
running the storer service.
