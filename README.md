# hab_haproxy

Modified version of upstream `core/haproxy` plan to allow for customization.

This service configuration is built for a single haproxy front-end with one back-end configuration.  Front-end `port` is exposed as `port` to gossip, allowing for binds.
