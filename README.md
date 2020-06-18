# uninvited_guest-guacamole-auth-hmac

## Description

This project is a plugin for [Guacamole](http://guac-dev.org), an HTML5 based
remote desktop solution supporting VNC/RFB, RDP, and SSH.

This plugin is an _authentication provider_ that enables stateless, on-the-fly
configuration of remote desktop connections that are authorized using a
pre-shared key. It is most appropriate for scenarios where you have an existing
user authentication & authorization mechanism.

## Building

Source code for the project starts under the `./extension` folder. In order to run the builds, please make sure your terminal context is under that folder.

`uninvited_guest-guacamole-auth-hmac` uses Maven for managing builds.
After installing Maven you can build a suitable jar for deployment
with `mvn package`.

The resulting jar file will be placed in
`extension/target/uninvited_guest-guacamole-auth-hmac-<version>.jar`.

**Please note:**

This plugin creates a jar file name identical to an [open source plugin][gsv-repo],
given it only has one slight difference in implementation details.
This alteration allows us to specify a `reservation` in the connection
url, which overrides any passwords set in `hmac-config.xml`. This is an
optional URL parameter.

[gsv-repo]: https://github.com/generalsystemsvehicle/uninvited_guest/

## Deployment & Configuration

**Warning:**

This plugin runs on Guacamole 1.1.0, so you must be running
at least that version before using this plugin.

Copy `uninvited_guest-guacamole-auth-hmac-config-<version>.jar` to the location specified by
[`lib-directory`][config-classpath] in `guacamole.properties`. You no
longer need to set then `auth-provider` property, as the latest versions
of guacamole auto load all included authentication provider extensions.

`uninvited_guest-guacamole-auth-hmac-config` adds three new config keys to `guacamole.properties`:

 * `hmac-server-id` - The key that represents the environment or pod
    that this guacamole server connects to. This is simply named `id` in
    the hmac signing process, and is used to prevent cross environment
    replays when the optional `reservation` parameter is not provided.
 * `secret-key` - The key that will be used to verify URL signatures.
    Whatever is generating the signed URLs will need to share this value.
 * `timestamp-age-limit` - A numeric value (in milliseconds) that determines how long
    a signed request should be valid for.

In addition you should include an `hmac-config.xml` file in the same directory as
`guacamole.properties`. This provides the system with a set named connections to select
from during the authentication process.

 We have provided [example hmac-config.xml and guacamole.properties][example-config] in `extension/src/test/resources`.

[example-config]: https://github.com/riverbedlab/uninvited_guest-guacamole-auth-hmac/tree/master/extension/src/test/resources

[config-classpath]: http://guac-dev.org/doc/gug/configuring-guacamole.html

## Usage

To generate a signed URL for usage with this plugin, simply use the path to
Guacamole's built-in `#/client/` as a base, and append the following query
parameters:

 * `reservation` - An optional override for the connection password in `hmac-config.xml`.
 * `timestamp` - A unix timestamp in milliseconds (i.e. `time() * 1000` in PHP).
   This is used to prevent replay attacks.
 * `connection` - The name of one of the provided connection configs in `hmac-config.xml`.
 * `signature` - The [request signature][#request-signing]

## Request Signing

Requests must be signed with an HMAC, where the message content is
generated from the request parameters as follows:

 1. The `timestamp` parameter
 2. For `id`, `connection`, `protocol` and `port`; append the key followed by value.

### Request Signing - Example

Given a request for the following URL:

`#/client/test-pc?reservation=10000001&timestamp=1373563683000&connection=test-pc&signature=79iLLJmCwnWSsHTzGG0z7rVUPOw%3D`

**Please note:** the `reservation` parameter is an optional override
for any default passwords provided in `hmac-config.xml`.

The message to be signed will be the concatenation of the following
strings:

  - timestamp: `"1373563683000"`
  - id: `"idpod_alias"`
  - connection: `"connectiontest-pc"`
  - protocol: `"protocolrdp"`
  - port: `"port3389"`

**Please note:** Again, the `id` is the `hmac-server-id` defined in `guacamole.properties`

Assuming a secret key of `"secret"`, a `signature` parameter should be appended
with a value that is the base-64 encoded value of the hash produced by signing
the message `"1373563683000idpod_aliasconnectiontest-pcprotocolrdpport3389"` with the key
`"secret"`, or `"79iLLJmCwnWSsHTzGG0z7rVUPOw="`. How
this signature is produced is dependent on your programming language/platform,
but with recent versions of PHP it looks like this:

    base64_encode(hash_hmac('sha1', $message, $secret));

Also, don't forget to `urlencode()` the `signature` parameter on the URL query string.

## Docker Test Environment

We are using a docker environment to handle testing. The simplest way to do a "build and run" is to follow these steps from the root of the project:

1. Run the shell script `up.sh`
2. In another shell session, run the shell script `create_hmac_url.sh`
3. Paste the URL generated into a browser

This should launch your into an RDP session hosted on a dockerized Ubuntu desktop instance.

The `up.sh` script runs the `mvn package` command inside the `extension` folder. It then runs the docker-composer to boot the environment. The `create_hmac_url.sh` script generates a signed URL using the rules of both the Guacamole client URL generator.

**Please note:**

You will want to modify the `guacamole.properties` and `hmac-config.xml`
files on the test server to match your necessary configuration. They are
located at `/etc/guacamole/`.

## License

Apache License 2.0
