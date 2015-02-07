# Ubiquity::Axle

A Library and Utilities to Interact with Axle

## Installation

### Pre-requisites

  - [git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - [ruby](https://www.ruby-lang.org/en/documentation/installation/)
  - rubygems
  - [bundler](http://bundler.io/#getting-started)

#### Install Pre-requisites on CentOS

Execute the following:

    $ yum install -y git ruby ruby-devel rubygems
    $ gem install bundler

### Install Using Git

Execute the following:

    $ git clone https://github.com/XPlatform-Consulting/ubiquity-axle.git
    $ cd vidispine
    $ bundle update

Or install it yourself using the specific_install gem:

    $ gem install specific_install
    $ gem specific_install https://github.com/XPlatform-Consulting/ubiquity-axle.git

## Axle API Executable [bin/ubiquity-axle](../bin/ubiquity-axle)

### Usage

    Usage:
        ubiquity-axle -h | --help

    Options:
          --host-address HOSTADDRESS   The address of the server to communicate with.
                                        default: localhost
          --host-port HOSTPORT         The port to use when communicating with the server.
                                        default: 80
          --method-name METHODNAME     The name of the method to call.
          --method-arguments JSON      The arguments to pass when calling the method.
          --pretty-print               Will format the output to be more human readable.
          --log-to FILENAME            Log file location.
                                        default: STDERR
          --log-level LEVEL            Logging level. Available Options: debug, info, warn, error, fatal
                                        default: debug
          --[no-]options-file [FILENAME]
                                       Path to a file which contains default command line arguments.
                                        default: /Users/jw/.options/ubiquity-axle
      -h, --help                       Display this message.


### Available API Methods

#### bin_create

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name bin_create --method-arguments '{"name": "Superbowl Commercial"}'

#### bin_delete

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name bin_delete --method-arguments '{"binId": 12321}'

#### bin_get

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name bin_get --method-arguments '{"binId": 12321}'

#### bins_get

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name bins_get

#### comment_create

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name comment_create --method-arguments '{"body":"Cool comment!", "itemIdentifier": "axle/12891230"}'

#### comment_delete

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name comment_delete --method-arguments '{"commentId":12901290}'

#### comment_edit

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name comment_edit --method-arguments '{"commentId":12901290, "body":"Really cool comment!"}'

#### file_get

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name file_get --method-arguments '{"filesystem":"axle", "fileId":12891230, "includeMetadata":false, "includeComments":false}'

#### file_items_get

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name file_items_get --method-arguments '{"filesystem":"axle", "fileId":238293898, "includeMetadata":false, "includeComments":false, "page":0}'

#### filesystem_operation_copy

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name filesystem_operation_copy --method-arguments '{"from":["axle/2342532", "axle/48394834"], "to": "axle/32902393984"}'

#### filesystem_operation_folder_create

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name filesystem_operation_folder_create --method-arguments '{"path": "axle/path/to/folder/newFolder"}'

#### filesystem_operation_move

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name filesystem_operation_move --method-arguments '{"from":["axle/2342532", "axle/48394834"], "to": "axle/32902393984"}'

#### metadata_edit

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name metadata_edit --method-arguments '{"itemIdentifier": "axle/12891230", "property":"Producer", "value": "Mike"}'

#### search

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name search --method-arguments '{"q": "stave", "includeMetadata":false, "includeComments":false, "page":0}'

#### subclip_create

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name subclip_create --method-arguments '{"fileIdentifier":"axle/18921289","binId":1290,"markIn":29.7,"markOut":39.0}'

#### subclip_get

    ubiquity-axle --host-address 127.0.0.1 --host-port 80 --method-name subclip_get --method-arguments '{"subClipId":82389}'

## Contributing

1. Fork it ( https://github.com/XPlatform-Consulting//ubiquity-axle/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
